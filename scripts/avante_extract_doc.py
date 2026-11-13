#!/usr/bin/env python3
# Extract readable text from binary documents for Avante @file context.
# Usage: python3 avante_extract_doc.py <path>
# Supported: pdf, docx, xlsx, pptx, odt, ods, csv, txt, md and other text.
# PDF needs pdftotext (poppler) or the pypdf / PyPDF2 Python package.
# DOCX, XLSX, PPTX and ODT are ZIP/XML formats handled with the stdlib.
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

NL = chr(10)
TAB = chr(9)


def local(tag):
    return tag.rsplit('}', 1)[-1]


def zip_root(path, member):
    with zipfile.ZipFile(path) as z:
        return ET.fromstring(z.read(member))


def docx_text(path):
    root = zip_root(path, 'word/document.xml')
    lines = []
    for p in root.iter():
        if local(p.tag) != 'p':
            continue
        text = ''.join(t.text or '' for t in p.iter() if local(t.tag) == 't')
        if text:
            lines.append(text)
    return NL.join(lines)


def pptx_text(path):
    slides = []
    with zipfile.ZipFile(path) as z:
        names = sorted(n for n in z.namelist() if n.startswith('ppt/slides/slide') and n.endswith('.xml'))
        for name in names:
            root = ET.fromstring(z.read(name))
            lines = []
            for p in root.iter():
                if local(p.tag) != 'p':
                    continue
                text = ''.join(t.text or '' for t in p.iter() if local(t.tag) == 't')
                if text:
                    lines.append(text)
            slides.append(NL.join(lines))
    return (NL + NL).join(slides)


def odt_text(path):
    root = zip_root(path, 'content.xml')
    lines = []
    for elem in root.iter():
        if local(elem.tag) in ('p', 'h'):
            text = ''.join(elem.itertext()).strip()
            if text:
                lines.append(text)
    return NL.join(lines)


def xlsx_text(path):
    try:
        import openpyxl
    except ImportError:
        raise RuntimeError('openpyxl is required for .xlsx: pip install openpyxl')
    wb = openpyxl.load_workbook(path, data_only=True, read_only=True)
    out = []
    for ws in wb.worksheets:
        out.append('## Sheet: ' + ws.title)
        for row in ws.iter_rows(values_only=True):
            if any(v is not None and str(v) != '' for v in row):
                out.append(TAB.join('' if v is None else str(v) for v in row))
    return NL.join(out)


def pdf_text(path):
    if shutil.which('pdftotext'):
        result = subprocess.run(['pdftotext', '-layout', str(path), '-'], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout
    for name in ('pypdf', 'PyPDF2'):
        try:
            module = __import__(name)
            reader = module.PdfReader(str(path))
            return NL.join((page.extract_text() or '') for page in reader.pages)
        except Exception:
            continue
    raise RuntimeError('No PDF extractor available: install poppler (pdftotext) or pip install pypdf')


def main():
    if len(sys.argv) != 2:
        print('Usage: avante_extract_doc.py <path>', file=sys.stderr)
        return 2
    path = Path(sys.argv[1])
    if not path.exists():
        print('File not found: ' + str(path), file=sys.stderr)
        return 1
    ext = path.suffix.lower()
    try:
        if ext == '.pdf':
            text = pdf_text(path)
        elif ext == '.docx':
            text = docx_text(path)
        elif ext == '.xlsx':
            text = xlsx_text(path)
        elif ext == '.pptx':
            text = pptx_text(path)
        elif ext in ('.odt', '.ods'):
            text = odt_text(path)
        elif ext in ('.txt', '.md', '.csv', '.tsv', '.json', '.xml', '.html'):
            text = path.read_text(encoding='utf-8', errors='replace')
        else:
            print('Unsupported file type: ' + ext, file=sys.stderr)
            return 1
    except Exception as exc:
        print('Failed to extract text: ' + str(exc), file=sys.stderr)
        return 1
    print(text)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
