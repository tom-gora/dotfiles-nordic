return {
  "goolord/alpha-nvim",
  opts = function()
    require("alpha")
    require("alpha.term")
    local dashboard = require("alpha.themes.dashboard")

    local width = 46
    local height = 24 -- two pixels per vertical space
    dashboard.section.terminal.command = "cat | " .. os.getenv("HOME") .. "/.config/nvim/art/thisisfine.sh"
    dashboard.section.terminal.width = width
    dashboard.section.terminal.height = height
    dashboard.section.terminal.opts.redraw = true

    dashboard.section.header.val = "████████████████████████████████████▓▒░⡷  𝙽 𝙴 𝙾 𝚅 𝙸 𝙼   ⢾░▒▓████████████████████████████████████"
    dashboard.config.layout = {
      { type = "padding", val = 0 },
      dashboard.section.terminal,
      { type = "padding", val = 4 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 0 },
      dashboard.section.footer,
    }

    return dashboard
  end,
}
