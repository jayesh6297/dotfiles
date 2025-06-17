-- basic autocommands
-- highlight in yank autocommand
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- cursor setting command after exiting neovim to set cursor to bliking bar
vim.api.nvim_create_autocmd("ExitPre", {
	group = vim.api.nvim_create_augroup("exit-cursor", { clear = true }),
	command = "set guicursor=a:blinkon250-ver100",
	desc = "Set cursor back to beam when leaving Neovim.",
})

-- Substitute carriage returns globally
vim.api.nvim_create_user_command("RemoveCRs", function()
	vim.cmd("%s/\\r//g")
end, {})
