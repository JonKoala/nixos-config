local module = {}

function module.apply_to_config(config)

  config.color_schemes = {
    ['Gruvbox dark hard'] = {
      foreground = '#d5c4a1',
      background = '#1d2021',

      cursor_bg = '#d5c4a1',
      cursor_fg = '#1d2021',
      cursor_border = '#d5c4a1',

      selection_fg = '#1d2021',
      selection_bg = '#fe8019',

      scrollbar_thumb = '#d5c4a1',

      ansi = {
        '#928374',
        '#fb4934',
        '#b8bb26',
        '#fabd2f',
        '#83a598',
        '#d3869b',
        '#8ec07c',
        '#ebdbb2'
      },
      brights = {
        '#928374',
        '#cc241d',
        '#98971a',
        '#d79921',
        '#458588',
        '#b16286',
        '#689d6a',
        '#a89984'
      }
    }
  }
end

return module
