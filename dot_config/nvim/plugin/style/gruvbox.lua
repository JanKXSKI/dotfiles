vim.pack.add({ "https://github.com/ellisonleao/gruvbox.nvim" })

require("gruvbox").setup({
    contrast = "soft",
    transparent_mode = true,
    italic = {
        strings = false,
        comments = false,
        folds = false
    }
})
vim.cmd.colorscheme("gruvbox")
