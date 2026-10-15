local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_callback = bind.map_callback
local helpers = require("keymap.helpers")

local mappings = {
	fmt = {
		["n|<A-f>"] = map_cr("FormatToggle"):with_noremap():with_silent():with_desc("格式化：开启／关闭保存时格式化"),
		["n|<A-S-f>"] = map_cr("Format"):with_noremap():with_silent():with_desc("格式化：格式化当前文件"),
	},
}
bind.nvim_load_mapping(mappings.fmt)

--- The following code allows this file to be exported ---
---    for use with LSP lazy-loaded keymap bindings    ---

local M = {}

---@param buf integer
function M.lsp(buf)
	local map = {
		-- LSP-related keymaps, ONLY effective in buffers with LSP(s) attached
		["n|<leader>li"] = map_cr("LspInfo"):with_silent():with_buffer(buf):with_desc("代码：查看语言服务信息"),
		["n|<leader>lr"] = map_cr("LspRestart"):with_silent():with_buffer(buf):with_nowait():with_desc("代码：重启语言服务"),
		["n|go"] = map_cr("Trouble symbols toggle win.position=right")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：显示／隐藏符号大纲"),
		["n|gto"] = map_callback(function()
				helpers.picker("lsp_document_symbols")
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：搜索当前文件符号"),
		["n|g["] = map_cr("Lspsaga diagnostic_jump_prev")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：上一个诊断"),
		["n|g]"] = map_cr("Lspsaga diagnostic_jump_next")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：下一个诊断"),
		["n|<leader>lx"] = map_cr("Lspsaga show_line_diagnostics ++unfocus")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：查看当前行诊断"),
		["n|gs"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end):with_desc("代码：查看函数参数提示"),
		["n|gr"] = map_cr("Lspsaga rename")
			:with_silent()
			:with_nowait()
			:with_buffer(buf)
			:with_desc("代码：在当前文件中重命名"),
		["n|gR"] = map_cr("Lspsaga rename ++project")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：在项目中重命名"),
		["n|K"] = map_cr("Lspsaga hover_doc"):with_silent():with_buffer(buf):with_desc("代码：查看文档"),
		["nv|ga"] = map_cr("Lspsaga code_action")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：选择代码操作"),
		["n|gd"] = map_cr("Lspsaga peek_definition")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：预览定义"),
		["n|gD"] = map_cr("Lspsaga goto_definition"):with_silent():with_buffer(buf):with_desc("代码：跳转到定义"),
		["n|gh"] = map_callback(function()
				helpers.picker("lsp_references")
			end)
			:with_noremap()
			:with_nowait()
			:with_silent()
			:with_desc("代码：查找引用"),
		["n|gm"] = map_callback(function()
				helpers.picker("lsp_implementations")
			end)
			:with_noremap()
			:with_nowait()
			:with_silent()
			:with_desc("代码：查找实现"),
		["n|gci"] = map_cr("Lspsaga incoming_calls")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：查看调用此函数的位置"),
		["n|gco"] = map_cr("Lspsaga outgoing_calls")
			:with_silent()
			:with_buffer(buf)
			:with_desc("代码：查看此函数调用的位置"),
		["n|<leader>lv"] = map_callback(function()
				helpers.toggle_virtuallines()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("代码：显示／隐藏诊断虚拟行"),
		["n|<leader>lh"] = map_callback(function()
				helpers.toggle_inlayhint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("代码：显示／隐藏内联提示"),
	}
	bind.nvim_load_mapping(map)

	local ok, user_mappings = pcall(require, "user.keymap.completion")
	if ok and type(user_mappings.lsp) == "function" then
		require("modules.utils.keymap").replace(user_mappings.lsp(buf))
	end
end

return M
