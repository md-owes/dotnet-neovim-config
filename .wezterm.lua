-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = { "C:\\Program Files\\Git\\usr\\bin\\bash.exe", "--login", "-i" }
config.initial_cols = 120
config.initial_rows = 28

-- Font Configuration Tip:
-- You previously showed an image with "JetBrainsMono Nerd Font Mono".
-- For best results in a terminal, ensure you use the monospaced version.
-- If "JetBrainsMono Nerd Font" isn't the monospaced one, change it to:
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.font_size = 14
config.color_scheme = "Material Vivid (base16)"

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("gui-startup", function(cmd)
	local default_shell_args = { "C:\\Program Files\\Git\\usr\\bin\\bash.exe", "--login", "-i" }

	-- Define your project directories (Windows paths for WezTerm's initial understanding)
	local project_front_dir_win = "C:\\REPO\\ADO\\Jaameah\\JaameahFront"
	local project_back_dir_win = "C:\\REPO\\ADO\\Jaameah\\JaameahBack"
	local project_backdeploy_dir_win = "C:\\REPO\\ADO\\Jaameah\\JaameahBack\\deployment"
	local chillbuddy_project_dir_win = "C:\\REPO\\ADO\\Chillbuddy\\chillbuddy"
	local chillbuddy_projectdeploy_dir_win = "C:\\REPO\\ADO\\Chillbuddy\\chillbuddy\\deployment"
	local learning_project_dir_win = "C:\\REPO\\GIT\\DataStructuresAndAlgorithms"
	local nvim_project_dir_win = "C:\\Users\\mdowe\\AppData\\Local\\nvim"

	-- Workspace 'Jaameah'
	-- Tab 1 (JaameahFront)
	local tab1_jaameah, pane1_jaameah, window_jaameah = mux.spawn_window({
		workspace = "Jaameah",
		cwd = project_front_dir_win, -- WezTerm will try to set this initially
		args = default_shell_args, -- Default bash login
	})
	tab1_jaameah:set_title("JaameahFront")
	wezterm.log_info("Jaameah Workspace, Tab 1 (Jaameah Front) spawned, attempting CWD: " .. project_front_dir_win)

	local tab2_jaameah = window_jaameah:spawn_tab({
		cwd = project_back_dir_win,
	})
	tab2_jaameah:set_title("JaameahBack")
	wezterm.log_info("Jaameah Workspace, Tab 2 (Jaameah Back) spawned with args to cd to: " .. project_back_dir_win)

	local tab3_jaameah = window_jaameah:spawn_tab({
		cwd = project_backdeploy_dir_win,
	})
	tab3_jaameah:set_title("JaameahDeploy")
	wezterm.log_info("Jaameah Workspace, Tab 3 (Jaameah Back Deployment) spawned with args to cd to: " .. project_backdeploy_dir_win)

	local tab4_jaameah = window_jaameah:spawn_tab({
		cwd = project_back_dir_win,
	})
	tab4_jaameah:set_title("JaameahProd")
	wezterm.log_info("Jaameah Workspace, Tab 4 (Jaameah Prod) spawned with args to cd to: " .. project_back_dir_win)

	-- Workspace 'ChillBuddy'
	-- For this one, if you only need one tab, you can use its project_dir_win in cwd
	-- or use a similar -c trick if needed.
	local tab1_chillbuddy, pane1_chillbuddy, window_chillbuddy = mux.spawn_window({
		workspace = "ChillBuddy",
		cwd = chillbuddy_project_dir_win,
		args = default_shell_args,
	})
	tab1_chillbuddy:set_title("Chillbuddy")
	wezterm.log_info("ChillBuddy Workspace, Tab 1 spawned, attempting CWD: " .. chillbuddy_project_dir_win)

	local tab2_chillbuddy = window_chillbuddy:spawn_tab({
		cwd = chillbuddy_projectdeploy_dir_win,
	})
	tab2_chillbuddy:set_title("ChillbuddyDeploy")
	wezterm.log_info("ChillBuddy Workspace, Tab 2 spawned, attempting CWD: " .. chillbuddy_projectdeploy_dir_win)

	local tab3_chillbuddy = window_chillbuddy:spawn_tab({
		cwd = chillbuddy_project_dir_win,
	})
	tab3_chillbuddy:set_title("ChillbuddyProd")
	wezterm.log_info("ChillBuddy Workspace, Tab 3 spawned, attempting CWD: " .. chillbuddy_project_dir_win)

	-- Workspace 'Learning'
	local tab1_learning, pane1_learning, window_learning = mux.spawn_window({
		workspace = "Learning",
		cwd = learning_project_dir_win,
		args = default_shell_args,
	})
	tab1_learning:set_title("LearningDSAlgo")
	wezterm.log_info("Learning Workspace, Tab 1 spawned, attempting CWD: " .. learning_project_dir_win)

	local tab2_learning = window_learning:spawn_tab({
		cwd = nvim_project_dir_win,
	})
	tab2_learning:set_title("NvimDirectory")
	wezterm.log_info("Learning Workspace, Tab 2 spawned, attempting CWD: " .. nvim_project_dir_win)

	-- Activate the 'Jaameah' workspace on startup
	mux.set_active_workspace("Jaameah")
	window_jaameah:gui_window():maximize()
end)

wezterm.on("window_close", function(window, pane)
  -- Instead of just closing the window, we perform the "QuitApplication" action.
  wezterm.perform_action(act.QuitApplication, window, pane)
end)

config.keys = {
	{ key = "1", mods = "ALT", action = act.SwitchToWorkspace({ name = "Jaameah" }) },
	{ key = "2", mods = "ALT", action = act.SwitchToWorkspace({ name = "ChillBuddy" }) },
	{ key = "3", mods = "ALT", action = act.SwitchToWorkspace({ name = "Learning" }) },
	{ key = "i", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace }, -- This prompts for a name
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
}

config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
}

config.window_close_confirmation = 'NeverPrompt'

return config

