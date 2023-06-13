return {

  -- NV chad style statusline variables

  -- add new user interface icon
  icons = {
    VimIcon = "",
    ScrollText = "",
    GitBranch = "",
    GitAdd = "",
    GitChange = "",
    GitDelete = "",
  },
  -- modify variables used by heirline but not defined in the setup call directly
  heirline = {
    -- define the separators between each section
    separators = {
      left = { "", " " }, -- separator for the left side of the statusline
      right = { " ", "" }, -- separator for the right side of the statusline
      tab = { "", "" },
    },
    -- add new colors that can be used by heirline
    colors = function(hl)
      local get_hlgroup = require("astronvim.utils").get_hlgroup
      -- use helper function to get highlight group properties
      local comment_fg = get_hlgroup("Comment").fg
      hl.git_branch_fg = comment_fg
      hl.git_added = comment_fg
      hl.git_changed = comment_fg
      hl.git_removed = comment_fg
      hl.blank_bg = get_hlgroup("Folded").fg
      hl.file_info_bg = get_hlgroup("Visual").bg
      hl.nav_icon_bg = get_hlgroup("String").fg
      hl.nav_fg = hl.nav_icon_bg
      hl.folder_icon_bg = get_hlgroup("Error").fg
      return hl
    end,
    attributes = {
      mode = { bold = true },
    },
    icon_highlights = {
      file_icon = {
        statusline = false,
      },
    },
  },

  -- set colorscheme

  colorscheme = "onenord",

  -- my plugins configs

  plugins = {

    -- own themes go here

    {
      "AlexvZyl/nordic.nvim",
      name = "nordic",
      config = function() require("nordic").setup {} end,
    },
    {
      "rmehri01/onenord.nvim",
      name = "onenord",
      config = function() require("onenord").setup {} end,
    },

    -- transparency
    {
      "xiyaowong/transparent.nvim",
      name = "transparent",
      lazy = false,
      opts = {
        -- groups = {}, -- table: default groups
        -- extra_groups = {}, -- table: additional groups that should be cleared
        -- exclude_groups = {"NotifyBackground"}, -- table: groups you don't want to clear
      },
    },

    -- notify fix for transparency

    {
      "rcarriga/nvim-notify",
      opts = { background_colour = "#2e3440" },
    },

    -- liveserver
    {
      "barrett-ruth/live-server.nvim",
      opts = {
        build = "yarn global add live-server",
        config = true,
      },
    },

    -- cutlass -> sane (non vim) behavior of deletions, changes and substiturions
    -- that leave the clipboard alone by using the black hole register

    {
      "gbprod/cutlass.nvim",
      keys = {
        "x",
        "d",
        "c",
        "X",
        "D",
        "C",
        "m",
      },
      lazy = false,
      config = function()
        require("cutlass").setup {
          exclude = { "ns", "nS" },
          cut_key = "<leader>x",
        }
      end,
    },

    -- tabnine

    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        {
          "codota/tabnine-nvim",
          build = "./dl_binaries.sh",
          config = function()
            require("tabnine").setup {
              disable_auto_comment = true,
              accept_keymap = "<C-i>",
              dismiss_keymap = "<C-]>",
              debounce_ms = 800,
              suggestion_color = { gui = "#4c566a", cterm = 244 }, -- let's see wha
              exclude_filetypes = { "TelescopePrompt" },
            }
          end,
        },
      },
      -- override the options table that is used in the require("cmp").setup() call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        -- modify the sources part of the options table
        opts.sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 800 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
          { name = "tabnine", priority = 9000 },
        }
        -- return the new table to be used
        return opts
      end,
    },

    -- Better `vim.notify()`
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
      },
    },

    -- paint to colorize markdown headers
    {
      "folke/paint.nvim",
      config = function()
        local hlmap = {
          ["^#%s+(.-)%s*$"] = "Operator",
          ["^##%s+(.-)%s*$"] = "Type",
          ["^###%s+(.-)%s*$"] = "String",
          ["^####%s+(.-)%s*$"] = "Constant",
          ["^#####%s+(.-)%s*$"] = "Number",
          ["^######%s+(.-)%s*$"] = "Error",
        }

        local highlights = {}
        for pattern, hl in pairs(hlmap) do
          table.insert(highlights, {
            filter = { filetype = "markdown" },
            pattern = pattern,
            hl = hl,
          })
        end

        require("paint").setup {
          ---@type PaintHighlight[]
          event = "Lazy",
          highlights = highlights,
        }
      end,
    },

    -- my alpha config

    {
      "goolord/alpha-nvim",
      cmd = "Alpha",
      opts = function()
        require "alpha"
        require "alpha.term"
        local dashboard = require "alpha.themes.dashboard"

        local width = 46
        local height = 24 -- two pixels per vertical space
        dashboard.section.terminal.command = "cat | " .. os.getenv "HOME" .. "/.config/AstroNvim/art/thisisfine.sh"
        dashboard.section.terminal.width = width
        dashboard.section.terminal.height = height
        dashboard.section.terminal.opts.redraw = true

        dashboard.section.header.val =
          "████████████████████████████████████▓▒░⡷   𝙽 𝙴 𝙾 𝚅 𝙸 𝙼   ⢾░▒▓████████████████████████████████████"
        dashboard.config.layout = {
          { type = "padding", val = 4 },
          dashboard.section.terminal,
          { type = "padding", val = 4 },
          dashboard.section.header,
          { type = "padding", val = 1 },
          dashboard.section.buttons,
          { type = "padding", val = 0 },
          dashboard.section.footer,
        }

        local button = require("astronvim.utils").alpha_button
        local get_icon = require("astronvim.utils").get_icon
        dashboard.section.buttons.val = {
          button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
          button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
          button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
          button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
          button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
          button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
        }
        return dashboard
      end,
      config = require "plugins.configs.alpha",
    },

    --treesitter configurations

    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
      -- event = "User AstroFile",
      cmd = {
        "TSBufDisable",
        "TSBufEnable",
        "TSBufToggle",
        "TSDisable",
        "TSEnable",
        "TSToggle",
        "TSInstall",
        "TSInstallInfo",
        "TSInstallSync",
        "TSModuleInfo",
        "TSUninstall",
        "TSUpdate",
        "TSUpdateSync",
      },
      build = ":TSUpdate",
      opts = {
        highlight = {
          enable = true,
          disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
        },
        incremental_selection = { enable = true },
        indent = { enable = true },
        autotag = {
          enable = true,
          filetypes = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "rescript",
            "xml",
            "php",
            "markdown",
            "astro",
            "glimmer",
            "handlebars",
            "hbs",
          },
          skip_tags = {
            "area",
            "base",
            "br",
            "col",
            "command",
            "embed",
            "hr",
            "img",
            "slot",
            "input",
            "keygen",
            "link",
            "meta",
            "param",
            "source",
            "track",
            "wbr",
            "menuitem",
          },
        },
        context_commentstring = { enable = true, enable_autocmd = false },
      },
      config = require "plugins.configs.nvim-treesitter",
    },

    -- heirline configured to NVchad style

    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"
        opts.statusline = {
          -- default highlight for the entire statusline
          hl = { fg = "fg", bg = "bg" },
          -- each element following is a component in astronvim.utils.status module

          -- add the vim mode component
          status.component.mode {
            -- enable mode text with padding as well as an icon before it
            mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
            -- surround the component with a separators
            surround = {
              -- it's a left element, so use the left separator
              separator = "left",
              -- set the color of the surrounding based on the current mode using astronvim.utils.status module
              color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
            },
          },
          -- we want an empty space here so we can use the component builder to make a new section with just an empty string
          status.component.builder {
            { provider = "" },
            -- define the surrounding separator and colors to be used inside of the component
            -- and the color to the right of the separated out section
            surround = { separator = "left", color = { main = "blank_bg", right = "file_info_bg" } },
          },
          -- add a section for the currently opened file information
          status.component.file_info {
            -- enable the file_icon and disable the highlighting based on filetype
            file_icon = { padding = { left = 0 } },
            filename = { fallback = "Empty" },
            -- add padding
            padding = { right = 1 },
            -- define the section separator
            surround = { separator = "left", condition = false },
          },
          -- add a component for the current git branch if it exists and use no separator for the sections
          status.component.git_branch { surround = { separator = "none" } },
          -- add a component for the current git diff if it exists and use no separator for the sections
          status.component.git_diff { padding = { left = 1 }, surround = { separator = "none" } },
          -- fill the rest of the statusline
          -- the elements after this will appear in the middle of the statusline
          status.component.fill(),
          -- add a component to display if the LSP is loading, disable showing running client names, and use no separator
          status.component.lsp { lsp_client_names = false, surround = { separator = "none", color = "bg" } },
          -- fill the rest of the statusline
          -- the elements after this will appear on the right of the statusline
          status.component.fill(),
          -- add a component for the current diagnostics if it exists and use the right separator for the section
          status.component.diagnostics { surround = { separator = "right" } },
          -- add a component to display LSP clients, disable showing LSP progress, and use the right separator
          status.component.lsp { lsp_progress = false, surround = { separator = "right" } },
          -- NvChad has some nice icons to go along with information, so we can create a parent component to do this
          -- all of the children of this table will be treated together as a single component
          {
            -- define a simple component where the provider is just a folder icon
            status.component.builder {
              -- astronvim.get_icon gets the user interface icon for a closed folder with a space after it
              { provider = require("astronvim.utils").get_icon "FolderClosed" },
              -- add padding after icon
              padding = { right = 1 },
              -- set the foreground color to be used for the icon
              hl = { fg = "bg" },
              -- use the right separator and define the background color
              surround = { separator = "right", color = "folder_icon_bg" },
            },
            -- add a file information component and only show the current working directory name
            status.component.file_info {
              -- we only want filename to be used and we can change the fname
              -- function to get the current working directory name
              filename = { fname = function(nr) return vim.fn.getcwd(nr) end, padding = { left = 1 } },
              -- disable all other elements of the file_info component
              file_icon = false,
              file_modified = false,
              file_read_only = false,
              -- use no separator for this part but define a background color
              surround = { separator = "none", color = "file_info_bg", condition = false },
            },
          },
          -- the final component of the NvChad statusline is the navigation section
          -- this is very similar to the previous current working directory section with the icon
          { -- make nav section with icon border
            -- define a custom component with just a file icon
            status.component.builder {
              { provider = require("astronvim.utils").get_icon "ScrollText" },
              -- add padding after icon
              padding = { right = 1 },
              -- set the icon foreground
              hl = { fg = "bg" },
              -- use the right separator and define the background color
              -- as well as the color to the left of the separator
              surround = { separator = "right", color = { main = "nav_icon_bg", left = "file_info_bg" } },
            },
            -- add a navigation component and just display the percentage of progress in the file
            status.component.nav {
              -- add some padding for the percentage provider
              percentage = { padding = { right = 1 } },
              -- disable all other providers
              ruler = false,
              scrollbar = false,
              -- use no separator and define the background color
              surround = { separator = "none", color = "file_info_bg" },
            },
          },
        }

        -- return the final options table
        return opts
      end,
    },

    { "NvChad/nvim-colorizer.lua", enabled = false },

    {
      "uga-rosa/ccc.nvim",
      lazy = false,
      opts = {
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      },
      keys = { { "<leader>P", "<cmd>CccPick<cr>", desc = "Toggle colorizer" } },
    },

    -- astrocommunnity things

    {
      "AstroNvim/astrocommunity",
      { import = "astrocommunity.utility.noice-nvim" },
      { import = "astrocommunity.utility.neodim" },
      { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
      { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
      { import = "astrocommunity.scrolling.mini-animate" },
      { import = "astrocommunity.motion.mini-surround" },
      -- { import = "astrocommunity.color.ccc-nvim" },

      -- { import = "astrocommunity.terminal-integration.flatten-nvim" },

      {
        "m4xshen/smartcolumn.nvim",
        opts = {
          colorcolumn = "120",
          disabled_filetypes = { "help", "text", "markdown", "lazy", "alpha", "mason", "checkhealth" },
          custom_colorcolumn = {},
          scope = "file",
        },
      },

      -- ... import any community contributed plugins here
    },
  },

  -- final polish

  polish = function()
    local opts = { noremap = true, silent = true, desc = "Toggle transparency" }
    local map = vim.api.nvim_set_keymap
    local set = vim.opt
    -- -- Set options
    -- set.relativenumber = true
    --
    -- -- Set key bindings
    -- map("n", "<C-s>", ":w!<CR>", opts)
    map("n", "<leader>uz", "<cmd>TransparentToggle<cr>", opts)
    opts = { noremap = true, silent = true, desc = " Live Server" }
    map("n", "<leader>E", "<cmd>LiveServerStop<cr>", opts)
    opts = { noremap = true, silent = true, desc = "Live Server ON" }
    map("n", "<leader>EE", "<cmd>LiveServerStart<cr>", opts)
    opts = { noremap = true, silent = true, desc = "Live Server OFF" }
    map("n", "<leader>ED", "<cmd>LiveServerStop<cr>", opts)
    opts = { noremap = true, silent = true, desc = "Toggle color highlighting" }
    map("n", "<leader>uC", "<cmd>CccHighlighterToggle<cr>", opts)
  end,
}
