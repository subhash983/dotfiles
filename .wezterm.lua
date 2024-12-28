local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-------------------------
--        Theme        --
-------------------------
-- config.color_scheme = 'Catppuccin Frappe'
-- config.color_scheme = 'Tomorrow Night Eighties'
-- config.color_scheme = 'Afterglow'
-- config.color_scheme = 'tokyonight-storm'
-- config.color_scheme = 'Everforest Dark (Gogh)'
-- config.color_scheme = 'rose-pine'
-- config.color_scheme = 'Dracula'
config.color_scheme = 'Material (base16)'

config.enable_tab_bar = true
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7
}

config.use_dead_keys = false
config.scrollback_lines = 10000
config.exit_behavior = 'Close'
config.default_cursor_style = 'BlinkingBlock'

config.font = wezterm.font_with_fallback {
    'Fira Code Nerd Font',
    'Hack Nerd Font',
  }
config.warn_about_missing_glyphs = true
config.font_size = 13
config.adjust_window_size_when_changing_font_size = false

---------------------------------
--   Remove padding for nvim   --
---------------------------------
-- local padding = {
--     left = '1cell',
--     right = '1cell',
--     top = '0.5cell',
--     bottom = '0.5cell',
-- }
-- 
-- wezterm.on('update-status', function(window, pane)
--     local overrides = window:get_config_overrides() or {}
--     if string.find(pane:get_title(), '^n-vi-m-.*') then
--         overrides.window_padding = {
--             left = 0,
--             right = 0,
--             top = 0,
--             bottom = 0
--         }
--     else
--         overrides.window_padding = padding
--     end
--     window:set_config_overrides(overrides)
-- end)

----------------------------
--    Toggle bg colors    --
----------------------------
local bg_colors = {'',
    '#233747',
    '#43273b',
    '#532507',
}
local current_color = 0

function toggle_background_color(window, pane)
    local overrides = window:get_config_overrides() or {}
    if bg_colors[1] == '' then
        bg_colors[1] = wezterm.get_builtin_color_schemes()[window:effective_config().color_scheme].background
    end

    current_color = math.fmod(current_color + 1, #bg_colors)
    overrides.colors = {
        background = bg_colors[current_color + 1],
    }
    window:set_config_overrides(overrides)
end

-------------------------
--     Keybindings     --
-------------------------
config.keys = {
    -- Window mgmt
    { key = 'n',   mods = 'CTRL|SHIFT', action = act.SpawnWindow },
    -- Tab mgmt
    { key = 'w',   mods = 'CTRL',       action = act.CloseCurrentTab { confirm = true } },
    { key = 'F4',  mods = 'CTRL',       action = act.CloseCurrentTab { confirm = true } },
    { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    -- Pane mgmt
    { key = 'n',   mods = 'ALT',        action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'm',   mods = 'ALT',        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'w',   mods = 'ALT',        action = act.CloseCurrentPane { confirm = true } },
    { key = 'h',   mods = 'ALT',        action = act.ActivatePaneDirection 'Left' },
    { key = 'j',   mods = 'ALT',        action = act.ActivatePaneDirection 'Down' },
    { key = 'k',   mods = 'ALT',        action = act.ActivatePaneDirection 'Up' },
    { key = 'l',   mods = 'ALT',        action = act.ActivatePaneDirection 'Right' },
    -- Search
    { key = 'f',   mods = 'CTRL',       action = act.Search { CaseSensitiveString = "" } },

    -- Toggle background color
    { key = 'M',   mods = 'CTRL',       action = wezterm.action_callback(toggle_background_color)},

    -- Debug mode
    { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
}

-- Backtrack search with Shift + Enter
local search_mode = nil
if wezterm.gui then
    search_mode = wezterm.gui.default_key_tables().search_mode
    table.insert(
        search_mode,
        { key = 'Enter', mods = 'SHIFT', action = act.CopyMode 'NextMatch' }
    )
end

config.key_tables = {
    search_mode = search_mode,
}

config.mouse_bindings = {
    { event = { Down = { streak = 1, button = "Right" } }, mods = 'NONE', action = act.PasteFrom 'Clipboard' },
}

config.check_for_updates = true
config.enable_wayland = true
config.window_background_opacity = 0.95

return config
