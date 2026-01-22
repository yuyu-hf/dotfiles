-- 行番号を表示
vim.opt.number = true

-- ファイルが外部で変更されたときに自動的に読み込む
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- ウィンドウ分割のキーマッピング
vim.keymap.set("n", "<C-a>|", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-a>-", "<cmd>split<CR>")

-- ウィンドウ間移動のキーマッピング
vim.keymap.set("n", "<C-a>l", "<C-w>l")
vim.keymap.set("n", "<C-a>j", "<C-w>h")
vim.keymap.set("n", "<C-a>k", "<C-w>j")
vim.keymap.set("n", "<C-a>i", "<C-w>k")

-- ファイル保存のキーマッピング
vim.keymap.set("n", "<C-a>s", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-a>s", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- タブ移動のキーマッピング
vim.keymap.set("n", "<C-a>]", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<C-a>[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<C-a>w", ":bdelete<CR>")

-- ステータスラインを非表示にする
vim.opt.laststatus = 3

-- lazy.nvimのインストールとセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})

-- config ディレクトリ以下の全ての lua ファイルを自動的に読み込む
local config_path = vim.fn.stdpath("config") .. "/lua/config"
for name, type in vim.fs.dir(config_path) do
	if type == "file" and name:match("%.lua$") then
		local module = name:gsub("%.lua$", "")
		require("config." .. module)
	end
end
