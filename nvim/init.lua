-- Setting options
vim.g.mapleader = " "

vim.opt.termguicolors = true          -- Enable 24-bit color

vim.opt.autoindent = true             -- Indent: Copy indent from current line when starting new line
vim.opt.clipboard = "unnamedplus"     -- Sync clipboard between OS and Neovim
vim.opt.cursorline = true             -- Show cursor line
vim.opt.expandtab = true              -- Use spaces to insert a tab
vim.opt.number = true                 -- Show line numbers
vim.opt.shiftwidth = 2                -- Indent/outdent by 2 spaces when using autoindent
vim.opt.softtabstop = 2               -- When pressing Tab or Backspace, insert/remove 2 spaces
vim.opt.smartindent = true
vim.opt.laststatus = 2                -- Always show status line
vim.opt.list = true                   -- Show tabs and trailing whitespace
vim.opt.listchars = "tab:>-,trail:·"  -- Set chars to show for tabs or trailing whitespace

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Use treesitter for folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false

-- Search
vim.opt.hlsearch = true               -- Highlight results
vim.opt.incsearch = true              -- Show results as you type
vim.opt.ignorecase = true             -- Ignore case
vim.opt.smartcase = true              -- unless uppercase chars are given

-- Plugin manager: lazy.nvim

-- Install lazy.nvim if not installed already
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim plugin manager")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ signcolumn = false, numhl = true})
    end,
    event = { "CursorHold", "CursorHoldI" },
    keys = {
      { "<leader>ghs", ":Gitsigns stage_hunk<cr>", desc = "Git stage hunk" },
      { "<leader>ghu", ":Gitsigns undo_stage_hunk<cr>", desc = "Git undo stage hunk" },
      { "<leader>ghr", ":Gitsigns reset_hunk<cr>", desc = "Git reset hunk" },
      { "]h", ":Gitsigns next_hunk<cr>", desc = "Gitsigns: Go to next hunk" },
      { "[h", ":Gitsigns prev_hunk<cr>", desc = "Gitsigns: Go to prev hunk" },
      { "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = {"o", "x"}, desc = "Text object for git hunks" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ruby_lsp", "lua_ls" },
        automatic_enable = true,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "Mofiqul/vscode.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "onedark",
          path = 1, -- show relative file path
        }
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'html', 'javascript', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'ruby', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then return end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  { "tpope/vim-bundler", ft = { "ruby", "eruby" } },
  { "tpope/vim-endwise", ft = { "ruby", "eruby" } },

  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>gbl", ":Git blame<cr>", desc = "Git blame" },
      { "<leader>ghp", ":!/opt/dev/bin/dev open pr &<cr><cr>", desc = "Github PR" },
      { "<leader>gs", ":Git<cr>", desc = "Git status" },
      { "<leader>gbr", ":GBrowse<cr>", desc = "Git browse", mode = { "n", "v" } },
    },
  },

  {
    "tpope/vim-rails",
    keys = {
      { "<leader>s", ":A<cr>", desc = "Toggle test and code files" },
    },
  },

  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-unimpaired", event = { "BufReadPost", "BufNewFile" } },
  { "vim-ruby/vim-ruby", event = { "BufReadPost", "BufNewFile" } },

  {
    "vim-test/vim-test",
    config = function() vim.g["test#strategy"] = "neoterm" end,
    keys = {
      { "<leader>tf", ":w<cr>:TestFile<cr>", desc = "Test current file" },
      { "<leader>tn", ":w<cr>:TestNearest<cr>", desc = "Test current file" },
      { "<leader>ts", ":w<cr>:TestSuite<cr>", desc = "Test suite" },
      { "<leader>tt", ":w<cr>:TestLast<cr>", desc = "Rerun last test" },
    },
  },
}

require("lazy").setup({
  spec = plugins
})

vim.cmd("colorscheme onedark_dark")

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

-- Buffers
vim.keymap.set("n", "<leader>bs", ":buffers<cr>")
vim.keymap.set("n", "<leader>b", ":buffer<cr>")
vim.keymap.set("n", "<leader>bn", ":bnext<cr>")
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>")
vim.keymap.set("n", "<leader>bd", ":bdelete<cr>")

-- Windows
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>cw", "<C-w>c")
vim.keymap.set("n", "<leader>wv", "<C-w>H")
vim.keymap.set("n", "<leader>ws", "<C-w>K")

vim.keymap.set("n", "<leader>/", "gcc")

-- Enable Ruby LSP
vim.lsp.enable('ruby_lsp')

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Removes trailing whitespace on save",
  group = vim.api.nvim_create_augroup("TrimTrailingWhitespace", { clear = true }),
  pattern = "*", -- Apply to all file types
  callback = function()
    -- Save and restore cursor position
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
