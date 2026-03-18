local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size = 12

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Atelier Heath (base16)"
	else
		return "Atelier Heath Light (base16)"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- Tab bar configuration
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 40
config.colors = {
	tab_bar = {
		background = "rgba(0, 0, 0, 0)",
	},
}

-- Make inactive panes less dark
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 0.95,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config)
	local appearance = get_appearance()
	local bg_color = appearance:find("Dark") and "#2E2E2E" or "#E8E8E8"
	local fg_color = appearance:find("Dark") and "#D4D4D4" or "#2E2E2E"
	local active_bg = appearance:find("Dark") and "#4A4A4A" or "#CCCCCC"

	local title = tab.active_pane.title
	if title == "" or title == "wezterm" then
		title = tab.active_pane.foreground_process_name
	end

	-- Truncate title to 30 characters and add padding for consistent tab width
	if #title > 30 then
		title = title
	elseif #title < 15 then
		title = string.format("%-15s", title)
	end

	return {
		{ Background = { Color = tab.is_active and active_bg or bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. tab.tab_index .. ": " .. title .. " " },
	}
end)

-- Tmux-style keybindings with Ctrl+a as leader
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = { -- Split panes
	{ key = "%", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	{ key = '"', mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Don't use ALT+Enter for wezterm, pass to apps
	{ key = "Enter", mods = "ALT", action = wezterm.action.SendKey({ key = "Enter", mods = "ALT" }) },

	-- Navigate panes with vim keybindings
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

	{ key = "o", mods = "LEADER", action = wezterm.action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },

	-- Navigate panes with arrow keys (tmux-style with Ctrl+a)
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Resize panes
	{ key = "H", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },

	-- Close pane
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- Zoom pane
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },

	-- New tab
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	-- Navigate tabs
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

	-- Move tabs
	{ key = ".", mods = "LEADER", action = wezterm.action.MoveTabRelative(1) },
	{ key = ",", mods = "LEADER", action = wezterm.action.MoveTabRelative(-1) },
	{
		key = "'",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new position (0-9):",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(wezterm.action.MoveTab(tonumber(line)), pane)
				end
			end),
		}),
	},

	-- Tab numbers
	{ key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
	{ key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
	{ key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
	{ key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
	{ key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(9) },

	-- Detach (equivalent to tmux detach)
	{ key = "d", mods = "LEADER", action = wezterm.action.QuitApplication },

	-- Copy mode
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

	-- Send literal Ctrl+a
	{ key = "a", mods = "LEADER", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },

	-- Close current pane with Cmd+X
	{ key = "x", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		-- Before
		--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
		--format = '$0',
		-- After
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},
}

return config
