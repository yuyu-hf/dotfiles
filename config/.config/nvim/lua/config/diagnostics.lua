-- 診断メッセージの表示設定
vim.diagnostic.config({
	virtual_text = true, -- 行末に診断メッセージを表示
	signs = true, -- サインカラムにアイコンを表示
	update_in_insert = false, -- 挿入モード中は更新しない
	underline = true, -- エラー箇所に下線を引く
	severity_sort = true, -- 重要度順にソート
	float = {
		border = "rounded",
		source = "always", -- 診断のソースを表示
		header = "",
		prefix = "",
	},
})

-- カーソルを合わせたときに診断メッセージを自動表示
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})
