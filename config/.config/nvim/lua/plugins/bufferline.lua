---@type LazyPluginSpec
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs",
				-- Neo-Treeの横幅分だけオフセット
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		})

		-- bufferlineの設定後に、カスタムタブライン関数を設定
		function _G.custom_tabline()
			local s = ""

			-- 現在のタブページでNeo-Treeが開いているかチェック
			local neo_tree_open = false
			local neo_tree_width = 30 -- neo-treeの横幅

			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.bo[buf].filetype
				if ft == "neo-tree" then
					neo_tree_open = true
					-- 実際の幅を取得
					neo_tree_width = vim.api.nvim_win_get_width(win)
					break
				end
			end

			-- Neo-Treeが開いている場合、オフセットを追加
			if neo_tree_open then
				s = s .. "%#TabLineFill#"
				s = s .. string.rep(" ", neo_tree_width)
			end

			for i = 1, vim.fn.tabpagenr("$") do
				local buflist = vim.fn.tabpagebuflist(i)

				-- タブ内のneo-tree以外のバッファを探す
				local display_name = "[No Name]"
				for _, bufnr in ipairs(buflist) do
					local ft = vim.fn.getbufvar(bufnr, "&filetype")
					local bufname = vim.fn.bufname(bufnr)
					if ft ~= "neo-tree" and bufname ~= "" then
						display_name = vim.fn.fnamemodify(bufname, ":t")
						break
					end
				end

				-- タブの選択状態
				local is_selected = (i == vim.fn.tabpagenr())

				-- ハイライトグループ
				s = s .. (is_selected and "%#TabLineSel#" or "%#TabLine#")

				-- タブ番号とファイル名
				s = s .. " " .. i .. ": " .. display_name .. " "

				-- 変更マークの追加（タブ内のいずれかのバッファが変更されている場合）
				for _, bufnr in ipairs(buflist) do
					if vim.fn.getbufvar(bufnr, "&modified") == 1 then
						s = s .. "[+] "
						break
					end
				end

				s = s .. "%#TabLineFill#"
			end

			-- 残りの部分を埋める
			s = s .. "%#TabLineFill#%T"

			return s
		end

		-- カスタムタブラインを設定（bufferlineの後に上書き）
		vim.o.tabline = "%!v:lua.custom_tabline()"
	end,
}
