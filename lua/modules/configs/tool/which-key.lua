return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		misc = require("modules.utils.icons").get("misc"),
		git = require("modules.utils.icons").get("git", true),
		cmp = require("modules.utils.icons").get("cmp", true),
		aichat = require("modules.utils.icons").get("aichat", true),
	}

	require("modules.utils").load_plugin("which-key", {
		preset = "classic",
		delay = vim.o.timeoutlen,
		triggers = {
			{ "<auto>", mode = "nixso" },
		},
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				motions = false,
				operators = false,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		win = {
			border = "none",
			padding = { 1, 2 },
			wo = { winblend = 0 },
		},
		expand = 1,
		icons = {
			group = "",
			rules = false,
			colors = false,
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			keys = {
				C = "C-",
				M = "A-",
				S = "S-",
				BS = "<BS> ",
				CR = "<CR> ",
				NL = "<NL> ",
				Esc = "<Esc> ",
				Tab = "<Tab> ",
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				Space = "<Space> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
			},
		},
		spec = {
			{ "<leader>g", group = icons.git.Git .. "Git" },
			{ "<leader>d", group = icons.ui.Bug .. " 调试" },
			{ "<leader>s", group = icons.cmp.tmux .. " 会话" },
			{ "<leader>b", group = icons.ui.Buffer .. " 缓冲区" },
			{ "<leader>S", group = icons.ui.Search .. " 搜索替换" },
			{ "<leader>W", group = icons.ui.Window .. " 窗口" },
			{ "<leader>p", group = icons.ui.Package .. " 插件管理" },
			{ "<leader>l", group = icons.misc.LspAvailable .. " 语言服务" },
			{ "<leader>f", group = icons.ui.Telescope .. " 查找" },
			{ "<leader>n", group = icons.ui.FolderOpen .. " 文件树" },
			{ "<leader>c", group = icons.aichat.Chat .. " AI 聊天" },
		},
	})
end
