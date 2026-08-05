vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

require("fzf-lua").setup({
    keymap = {
        fzf = {
	    ["ctrl-c"] = "abort",
	},
    }
})
