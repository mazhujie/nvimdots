require("keymap.helpers")
local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	core = {
		-- Package manager: lazy.nvim
		["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("插件：打开插件管理器"),
		["n|<leader>ps"] = map_cr("Lazy sync"):with_silent():with_noremap():with_nowait():with_desc("插件：同步插件"),
		["n|<leader>pu"] = map_cr("Lazy update")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件：更新插件"),
		["n|<leader>pi"] = map_cr("Lazy install")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件：安装插件"),
		["n|<leader>pl"] = map_cr("Lazy log"):with_silent():with_noremap():with_nowait():with_desc("插件：查看插件更新日志"),
		["n|<leader>pc"] = map_cr("Lazy check"):with_silent():with_noremap():with_nowait():with_desc("插件：检查插件更新"),
		["n|<leader>pd"] = map_cr("Lazy debug"):with_silent():with_noremap():with_nowait():with_desc("插件：查看插件调试信息"),
		["n|<leader>pp"] = map_cr("Lazy profile")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件：查看插件性能"),
		["n|<leader>pr"] = map_cr("Lazy restore")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件：按锁定版本恢复插件"),
		["n|<leader>px"] = map_cr("Lazy clean"):with_silent():with_noremap():with_nowait():with_desc("插件：清理未使用的插件"),
	},
}

bind.nvim_load_mapping(mappings.core)

-- Builtin & Plugin keymaps
require("keymap.completion")
require("keymap.editor")
require("keymap.lang")
require("keymap.tool")
require("keymap.ui")

-- User keymaps
local ok, def = pcall(require, "user.keymap.init")
if ok then
	require("modules.utils.keymap").replace(def)
end
