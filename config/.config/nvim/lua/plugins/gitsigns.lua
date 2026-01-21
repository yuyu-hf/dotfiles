-- Ref: https://zenn.dev/vim_jp/articles/1b4344e41b9d5b
---@type LazyPluginSpec
return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- `:Gitsigns toggle_signs`でトグル
			numhl = false, -- `:Gitsigns toggle_numhl`でトグル
			linehl = false, -- `:Gitsigns toggle_linehl`でトグル
			word_diff = false, -- `:Gitsigns toggle_word_diff`でトグル
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- `:Gitsigns toggle_current_line_blame`でトグル
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'（行末 | オーバーレイ | 右揃え）
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- デフォルトを使用
			max_file_length = 40000, -- この行数より長いファイルは無効化
			preview_config = {
				-- nvim_open_winに渡されるオプション
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
	end,
}
