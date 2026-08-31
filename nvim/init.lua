-- Setting options
vim.g.mapleader = " "

vim.o.termguicolors = true            -- Enable 24-bit color
vim.o.cursorline = true               -- Show cursor line
vim.o.expandtab = true                -- Use spaces to insert a tab
vim.o.number = true                   -- Show line numbers
vim.o.shiftwidth = 2                  -- Indent/outdent by 2 spaces when using autoindent
vim.o.softtabstop = 2                 -- When pressing Tab or Backspace, insert/remove 2 spaces
vim.o.smartindent = true
vim.o.laststatus = 2                  -- Always show status line
vim.o.list = true                     -- Show tabs and trailing whitespace
vim.o.listchars = "tab:>-,trail:·"    -- Set chars to show for tabs or trailing whitespace
vim.o.mouse = "a"                     -- Enable mouse mode, useful for resizing splits
vim.o.showmode = false                -- Mode is already in the status line
vim.o.breakindent = true
vim.o.undofile = true                 -- Keep undo history after closing and reopening a file
vim.o.ignorecase = true               -- Case-insensitive searching...
vim.o.smartcase = true                -- ...unless \C or capital letters in the search term
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300                -- Decrease mapped sequence wait time
vim.o.splitright = true
vim.o.splitbelow = true

-- Sync clipboard between OS and Neovim. Scheduled after UiEnter because it can
-- increase startup time.
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- Use treesitter for folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false

-- Plugins, managed with Neovim's built-in package manager (:h vim.pack).
-- Update with :lua vim.pack.update()

-- telescope-fzf-native ships a C extension that must be compiled on install/update
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("PackBuildHooks", { clear = true }),
  callback = function(ev)
    if ev.data.kind ~= "delete" and ev.data.spec.name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  "https://github.com/olimorris/onedarkpro.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/tpope/vim-bundler",
  "https://github.com/tpope/vim-endwise",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  "https://github.com/tpope/vim-rails",
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/vim-ruby/vim-ruby",
  "https://github.com/vim-test/vim-test",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
})

vim.cmd("colorscheme onedark_dark")

-- Highlight todo, notes, etc in comments
require("todo-comments").setup({ signs = false })

require("gitsigns").setup({ signcolumn = false, numhl = true })
vim.keymap.set("n", "<leader>ghs", ":Gitsigns stage_hunk<cr>", { desc = "Git stage hunk" })
vim.keymap.set("n", "<leader>ghu", ":Gitsigns undo_stage_hunk<cr>", { desc = "Git undo stage hunk" })
vim.keymap.set("n", "<leader>ghr", ":Gitsigns reset_hunk<cr>", { desc = "Git reset hunk" })
vim.keymap.set("n", "]h", ":Gitsigns next_hunk<cr>", { desc = "Gitsigns: Go to next hunk" })
vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<cr>", { desc = "Gitsigns: Go to prev hunk" })
vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Text object for git hunks" })

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ruby_lsp", "lua_ls" },
  automatic_enable = true,
})

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "onedark",
    path = 1, -- show relative file path
  },
})

require("nvim-tree").setup({})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

local parsers = { "bash", "c", "diff", "html", "javascript", "lua", "luadoc", "markdown", "markdown_inline", "query", "ruby", "vim", "vimdoc" }
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    -- check if parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- enables treesitter based indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Fugitive
vim.keymap.set("n", "<leader>gbl", ":Git blame<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>ghp", ":!/opt/dev/bin/dev open pr &<cr><cr>", { desc = "Github PR" })
vim.keymap.set("n", "<leader>gs", ":Git<cr>", { desc = "Git status" })
vim.keymap.set({ "n", "v" }, "<leader>gbr", ":GBrowse<cr>", { desc = "Git browse" })

-- Rails
vim.keymap.set("n", "<leader>s", ":A<cr>", { desc = "Toggle test and code files" })

-- vim-test
vim.g["test#strategy"] = "neoterm"
vim.keymap.set("n", "<leader>tf", ":w<cr>:TestFile<cr>", { desc = "Test current file" })
vim.keymap.set("n", "<leader>tn", ":w<cr>:TestNearest<cr>", { desc = "Test nearest" })
vim.keymap.set("n", "<leader>ts", ":w<cr>:TestSuite<cr>", { desc = "Test suite" })
vim.keymap.set("n", "<leader>tt", ":w<cr>:TestLast<cr>", { desc = "Rerun last test" })

-- Telescope fuzzy finder. See `:help telescope` and `:help telescope.builtin`
require("telescope").setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "[ ] Search Files" })
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

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

-- Enable Ruby LSP
vim.lsp.enable("ruby_lsp")

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Removes trailing whitespace on save",
  group = vim.api.nvim_create_augroup("TrimTrailingWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    -- Save and restore cursor position
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
