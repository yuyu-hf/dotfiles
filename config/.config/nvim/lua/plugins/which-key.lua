---@type LazyPluginSpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<C-a>?",
			function()
				require("which-key").show({ keys = "<C-a>", loop = false })
			end,
			desc = "Show <C-a> keymaps",
		},
	},
	config = function()
		local wk = require("which-key")
		wk.setup({})
		wk.add({
			{ "<C-a>", group = "Custom Commands" },
			{ "<C-a>e", desc = "Toggle Neo-Tree" },
			{ "<C-a>E", desc = "Toggle Neo-Tree (cwd)" },
			{ "<C-a>s", desc = "Save file" },
			{ "<C-a>w", desc = "Close tab" },
			{ "<C-a>]", desc = "Next tab" },
			{ "<C-a>[", desc = "Previous tab" },
			{ "<C-a>d", desc = "Delete buffer" },
			{ "<C-a>|", desc = "Vertical split" },
			{ "<C-a>-", desc = "Horizontal split" },
			{ "<C-a>l", desc = "Move to right window" },
			{ "<C-a>j", desc = "Move to left window" },
			{ "<C-a>k", desc = "Move to down window" },
			{ "<C-a>i", desc = "Move to up window" },
			{ "<C-a>/", desc = "Toggle comment" },
			{ "<C-a>?", desc = "Show local keymaps" },
		})
	end,
}
