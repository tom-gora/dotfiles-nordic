for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      "Error setting up colorscheme: " .. astronvim.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)

-- my configs

-- themes
-- require("onenord").setup()
require("nordic").setup()

-- plugins
require("live-server").setup {
  -- Arguments passed to live-server via `vim.fn.jobstart()`
  -- Run `live-server --help` to see list of available options
  -- For example, to use port 7000 and browser firefox:
  args = { "--port=7000", "--browser=chromium" },
}
