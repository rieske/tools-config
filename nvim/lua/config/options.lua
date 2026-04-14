-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "light"

-- Files
vim.opt.swapfile = false

-- UI
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.linespace = 4
vim.opt.showbreak = "..."
vim.opt.linebreak = true
vim.opt.visualbell = true
vim.opt.updatetime = 100
vim.opt.showmode = false
vim.opt.signcolumn = "yes"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Wildmenu
vim.opt.wildmode = "list:longest"
vim.opt.wildignore:append({
  "*.o", "*.obj", "*.class", "*.so",
  "*.gcda", "*.gcov", "*.gcno",
  "*.lo", "*.la", "*.out",
})

-- Completion
vim.opt.complete = { ".", "w", "b", "u", "t", "i" }
vim.opt.completeopt = { "menu", "popup" }

-- Tags
vim.opt.tags:append("~/.system.tags")

-- Persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Allow project-local config
vim.opt.exrc = true

-- nvim-tree replaces netrw; disable before plugins load.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
