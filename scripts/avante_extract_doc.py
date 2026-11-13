#!/usr/bin/env python3
# Extract readable text from binary documents for Avante @file context.
# Usage: python3 avante_extract_doc.py <path>
# Supported: pdf, docx, xlsx, pptx, odt, ods, csv, txt, md and other text.
# PDF needs pdftotext (poppler) or the pypdf / PyPDF2 Python package.
# DOCX, XLSX, PPTX and ODT are ZIP/XML formats handled with the stdlib.
#
# Why Python: the doc-parsing ecosystem is here (stdlib ZIP/XML, openpyxl,
# pypdf) and extraction is I/O-bound and infrequent, so a compiled rewrite
# would shell out to the same tools or use less mature parsers for no real
# gain. This version is instead optimized for streaming (constant memory
# on large files), bounded work (size / zip-bomb / timeout limits) and
# resilience (per-page and per-sheet failures do not lose the whole file).
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

NL = chr(10)
TAB = chr(9)

# Bounds so a hostile or accidental huge file cannot exhaust memory,
# disk or the caller's time. Output is truncated, never silently huge.
MAX_FILE_BYTES = 100 * 1024 * 1024
MAX_MEMBER_BYTES = 100 * 1024 * 1024
MAX_UNCOMPRESSED_BYTES = 300 * 1024 * 1024
MAX_OUTPUT_CHARS = 2_000_000
MAX_ROWS_PER_SHEET = 100_000
PDFTOTEXT_TIMEOUT_SECONDS = 30
TEXT_EXTS = ('.txt', '.md', '.csv', '.tsv', '.json', '.xml', '.html')


class ExtractionError(RuntimeError):
    pass


def local_name(tag):
    return tag.rsplit('}', 1)[-1] if isinstance(tag, str) else ''


def checked_zip(path):
    # Reject zip bombs before reading anything: total and per-member
    # uncompressed sizes are checked from the central directory.
    archive = zipfile.ZipFile(path)
    total = 0
    for info in archive.infolist():
        if info.file_size > MAX_MEMBER_BYTES:
            archive.close()
            raise ExtractionError('ZIP member too large: ' + info.filename)
        total += info.file_size
        if total > MAX_UNCOMPRESSED_BYTES:
            archive.close()
            raise ExtractionError('Archive expands beyond the size limit')
    return archive


def iter_paragraphs(stream, text_tags):
    # Streaming parse: paragraphs are yielded and cleared as they close,
    # so memory stays flat no matter how large the XML member is.
    for _event, elem in ET.iterparse(stream, events=('end',)):
        if local_name(elem.tag) in ('p', 'h'):
            if text_tags is None:
                text = ''.join(elem.itertext()).strip()
            else:
                text = ''.join(node.text or '' for node in elem.iter() if local_name(node.tag) in text_tags)
            if text:
                yield text
            elem.clear()


def open_member(archive, member):
    try:
        return archive.open(member)
    except KeyError:
        raise ExtractionError('Missing ' + member + ' in archive')


def docx_text(path):
    with checked_zip(path) as archive, open_member(archive, 'word/document.xml') as stream:
        return NL.join(iter_paragraphs(stream, {'t'}))


def slide_number(name):
    match = re.search(r'(\d+)\.xml$', name)
    return int(match.group(1)) if match else 0


def pptx_text(path):
    slides = []
    with checked_zip(path) as archive:
        names = [n for n in archive.namelist() if n.startswith('ppt/slides/slide') and n.endswith('.xml')]
        for name in sorted(names, key=slide_number):
            with open_member(archive, name) as stream:
                slides.append(NL.join(iter_paragraphs(stream, {'t'})))
    return (NL + NL).join(s for s in slides if s)


def odt_text(path):
    with checked_zip(path) as archive, open_member(archive, 'content.xml') as stream:
        return NL.join(iter_paragraphs(stream, None))


def xlsx_text(path):
    try:
        import openpyxl
    except ImportError:
        raise ExtractionError('openpyxl is required for .xlsx: pip install openpyxl')
    workbook = openpyxl.load_workbook(path, data_only=True, read_only=True)
    try:
        out = []
        for sheet in workbook.worksheets:
            out.append('## Sheet: ' + sheet.title)
            for row_number, row in enumerate(sheet.iter_rows(values_only=True)):
                if row_number >= MAX_ROWS_PER_SHEET:
                    out.append('[Sheet truncated at ' + str(MAX_ROWS_PER_SHEET) + ' rows]')
                    break
                if any(v is not None and str(v) != '' for v in row):
                    out.append(TAB.join('' if v is None else str(v) for v in row))
        return NL.join(out)
    finally:
        workbook.close()


def pdf_with_pdftotext(path):
    try:
        result = subprocess.run(['pdftotext', '-layout', str(path), '-'], capture_output=True, text=True, timeout=PDFTOTEXT_TIMEOUT_SECONDS, check=False)
    except (OSError, subprocess.TimeoutExpired):
        return None
    return result.stdout if result.returncode == 0 and result.stdout else None


def pdf_with_python(path):
    for name in ('pypdf', 'PyPDF2'):
        try:
            module = __import__(name)
        except ImportError:
            continue
        reader = module.PdfReader(str(path))
        pages = []
        for page in reader.pages:
            try:
                pages.append(page.extract_text() or '')
            except Exception:
                pages.append('')  # One bad page must not lose the rest.
        return NL.join(pages)
    return None


def pdf_text(path):
    text = pdf_with_pdftotext(path)
    if text is None:
        text = pdf_with_python(path)
    if text is None:
        raise ExtractionError('No PDF extractor available: install poppler (pdftotext) or pip install pypdf')
    return text


def plain_text(path):
    parts = []
    total = 0
    with path.open('r', encoding='utf-8-sig', errors='replace') as handle:
        while total <= MAX_OUTPUT_CHARS:
            chunk = handle.read(65536)
            if not chunk:
                break
            parts.append(chunk)
            total += len(chunk)
    return ''.join(parts)


EXTRACTORS = {
    '.pdf': pdf_text,
    '.docx': docx_text,
    '.xlsx': xlsx_text,
    '.pptx': pptx_text,
    '.odt': odt_text,
    '.ods': odt_text,
}


def extract(path):
    ext = path.suffix.lower()
    if ext in TEXT_EXTS:
        return plain_text(path)
    extractor = EXTRACTORS.get(ext)
    if extractor is None:
        raise ExtractionError('Unsupported file type: ' + (ext or '(none)'))
    return extractor(path)


def main():
    if len(sys.argv) != 2:
        print('Usage: avante_extract_doc.py <path>', file=sys.stderr)
        return 2
    path = Path(sys.argv[1])
    if not path.is_file():
        print('File not found: ' + str(path), file=sys.stderr)
        return 1
    try:
        if path.stat().st_size > MAX_FILE_BYTES:
            raise ExtractionError('File exceeds the size limit')
        text = extract(path)
    except (ExtractionError, zipfile.BadZipFile, ET.ParseError, OSError) as exc:
        print('Failed to extract text: ' + str(exc), file=sys.stderr)
        return 1
    if len(text) > MAX_OUTPUT_CHARS:
        text = text[:MAX_OUTPUT_CHARS] + NL + NL + '[Output truncated at ' + str(MAX_OUTPUT_CHARS) + ' characters]'
    try:
        sys.stdout.write(text + NL)
    except BrokenPipeError:
        return 0
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
