vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.o.clipboard = "unnamedplus"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("nvim-treesitter.install").compilers = { "gcc" } -- Optional: Configure compiler selection
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "vim", -- For vimscript
    "regex", -- For regex
    "lua", -- For lua
    "bash", -- For bash
    "markdown", -- For markdown
    "markdown_inline", -- For markdown_inline
    "jsonc", -- For jsonc
  },
  highlight = {
    enable = true, -- Enable syntax highlighting
  },
})
require("onenord").setup()
require("lualine").setup({
  options = {
    component_separators = "|",
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", "branch" },
    lualine_c = { "fileformat" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { right = "" }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {},
})
vim.opt.termguicolors = true

require("bufferline").setup({
  options = {
    separator_style = "|",
  },
})
require("barbecue").setup({
  theme = {
    -- this highlight is used to override other highlights
    -- you can take advantage of its `bg` and set a background throughout your winbar
    -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
    normal = { fg = "#c0caf5" },

    -- these highlights correspond to symbols table from config
    ellipsis = { fg = "#737aa2" },
    separator = { fg = "#737aa2" },
    modified = { fg = "#737aa2" },

    -- these highlights represent the _text_ of three main parts of barbecue
    dirname = { fg = "#737aa2" },
    basename = { bold = true },
    context = {},

    -- these highlights are used for context/navic icons
    context_file = { fg = "#ac8fe4" },
    context_module = { fg = "#ac8fe4" },
    context_namespace = { fg = "#ac8fe4" },
    context_package = { fg = "#ac8fe4" },
    context_class = { fg = "#ac8fe4" },
    context_method = { fg = "#ac8fe4" },
    context_property = { fg = "#ac8fe4" },
    context_field = { fg = "#ac8fe4" },
    context_constructor = { fg = "#ac8fe4" },
    context_enum = { fg = "#ac8fe4" },
    context_interface = { fg = "#ac8fe4" },
    context_function = { fg = "#ac8fe4" },
    context_variable = { fg = "#ac8fe4" },
    context_constant = { fg = "#ac8fe4" },
    context_string = { fg = "#ac8fe4" },
    context_number = { fg = "#ac8fe4" },
    context_boolean = { fg = "#ac8fe4" },
    context_array = { fg = "#ac8fe4" },
    context_object = { fg = "#ac8fe4" },
    context_key = { fg = "#ac8fe4" },
    context_null = { fg = "#ac8fe4" },
    context_enum_member = { fg = "#ac8fe4" },
    context_struct = { fg = "#ac8fe4" },
    context_event = { fg = "#ac8fe4" },
    context_operator = { fg = "#ac8fe4" },
    context_type_parameter = { fg = "#ac8fe4" },
  },
})
require("live-server").setup({
  -- Arguments passed to live-server via `vim.fn.jobstart()`
  -- Run `live-server --help` to see list of available options
  -- For example, to use port 7000 and browser firefox:
  args = { "--port=7000", "--browser=chromium" },
})

require("colorizer").setup({
  filetypes = {
    "*", -- Highlight all files, but customize some others.
    css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
    html = { names = false }, -- Disable parsing "names" like Blue or Gray
    lua = { names = false }, -- Disable parsing "names" like Blue or Gray
    mason = { names = false }, -- Disable parsing "names" like Blue or Gray
    lazy = { names = false }, -- Disable parsing "names" like Blue or Gray
    checkhealth = { names = false }, -- Disable parsing "names" like Blue or Gray
    alpha = { names = false }, -- Disable parsing "names" like Blue or Gray
  },
  cmp_docs = { always_update = true },
})

require("smartcolumn").setup({
  colorcolumn = "98",
  disabled_filetypes = { "help", "text", "markdown", "lazy", "alpha", "mason", "checkhealth" },
  custom_colorcolumn = {},
  scope = "file",
})

-- user command to toggle focus between Neotree and current buffer
vim.api.nvim_create_user_command("ToggleNeotreeFocus", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd("p")
  else
    vim.cmd.Neotree("focus")
  end
end, {})
