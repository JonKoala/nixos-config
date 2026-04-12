local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 11

require('colorschemes').apply_to_config(config)
config.color_scheme = 'Gruvbox dark hard'

config.window_background_opacity = 0.95

config.hide_tab_bar_if_only_one_tab = true

config.term = 'wezterm'

return config
