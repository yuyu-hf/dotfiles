-- Ref: https://zenn.dev/vim_jp/articles/1b4344e41b9d5b
---@type LazyPluginSpec
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- サイズは数値または現在のターミナルを引数として受け取る関数
			size = 20,
			open_mapping = [[<C-a>tt]], -- 日本語キーボードの場合は { [[<c-\>]], [[<c-¥>]] } も使用可能
			hide_numbers = true, -- toggletermバッファで行番号を非表示
			shade_filetypes = {},
			autochdir = false, -- neovimがカレントディレクトリを変更したとき、次回開いた際にターミナルも変更する
			shade_terminals = true, -- 注意: このオプションは指定されたハイライトより優先されるため、Normalハイライトを指定する場合はfalseに設定
			start_in_insert = true,
			insert_mappings = true, -- インサートモードでopen mappingを適用するかどうか
			terminal_mappings = true, -- 開かれたターミナル内でopen mappingを適用するかどうか
			persist_size = true,
			persist_mode = true, -- trueに設定すると（デフォルト）前回のターミナルモードが記憶される
			direction = "float",
			close_on_exit = true, -- プロセス終了時にターミナルウィンドウを閉じる
			clear_env = false, -- jobstartに渡される`env`の環境変数のみを使用
			-- デフォルトシェルを変更。文字列または文字列を返す関数
			shell = vim.o.shell,
			auto_scroll = true, -- ターミナル出力時に自動的に最下部にスクロール
			-- このフィールドはdirectionが'float'に設定されている場合のみ有効
			float_opts = {
				border = "curved",
				winblend = 3,
				title_pos = "center",
			},
			winbar = {
				enabled = false,
				name_formatter = function(term) --  term: Terminal
					return term.name
				end,
			},
		})
	end,
}
