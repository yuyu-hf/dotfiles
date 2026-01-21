---@type LazyPluginSpec
return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	opts = {
		-- デフォルトのキーマップを無効化（<C-a>/のみ使用）
		mappings = {
			basic = false,
			extra = false,
		},
	},
	config = function(_, opts)
		require("Comment").setup(opts)

		-- <C-a>/ でコメント/コメント解除（ノーマルモード）
		vim.keymap.set("n", "<C-a>/", function()
			return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_linewise_current)"
				or "<Plug>(comment_toggle_linewise_count)"
		end, { expr = true, desc = "Toggle comment" })

		-- <C-a>/ でコメント/コメント解除（ビジュアルモード）
		vim.keymap.set("x", "<C-a>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
	end,
}
