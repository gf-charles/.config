-- line number settings
vim.opt.number = true
vim.opt.rnu = true

-- tab settings
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

-- leader/localleader
vim.g.mapleader = " "
vim.g.maplocalleader = ','

-- % matching, add pairs
vim.opt.matchpairs:append("':'")
vim.opt.matchpairs:append('":"')

-- misc
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'
vim.opt.autochdir = true
vim.opt.scrolloff = 999
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.wo.foldlevel = 99 -- all folds open by default
vim.wo.conceallevel = 2 -- overlay raw characters


