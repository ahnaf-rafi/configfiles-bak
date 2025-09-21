local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Gruvbox dark, hard (base16)'

-- config.font = wezterm.font 'Fira Code'
config.font = wezterm.font_with_fallback {
  'JuliaMono',
  'JetBrains Mono'
}
config.font_size = 12.0

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

return config
