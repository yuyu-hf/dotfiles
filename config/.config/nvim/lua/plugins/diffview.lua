-- https://zenn.dev/vim_jp/articles/1b4344e41b9d5b
---@type LazyPluginSpe
return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup()
	end,
	lazy = false,
	keys = {
		{ mode = "n", "<C-h>d", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "1つ前とのdiff" },
		{ mode = "n", "<C-h>h", "<cmd>DiffviewFileHistory %<CR>", desc = "ファイルの変更履歴" },
		{ mode = "n", "<C-h><BS>", "<cmd>DiffviewClose<CR>", desc = "diffの画面閉じる" },
	},
}
