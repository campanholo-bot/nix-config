vim.o.number = true
vim.o.relativenumber = true

-- Selenized's black-and-white scheme is Selenized Black on a dark background.
-- Without true colour set first, the scheme picks its two-colour version.
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("selenized_bw")
