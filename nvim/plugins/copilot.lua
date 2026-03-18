local status_copilot, copilot = pcall(require, "copilot")
if status_copilot then
	copilot.setup({
		panel = { auto_refresh = true },
		suggestion = {
			auto_trigger = true,
			hide_during_completion = false,
			keymap = { accept = "<M-Space>" },
		},
		filetypes = { yaml = true, gitcommit = true },
	})
end

local status_chat, copilot_chat = pcall(require, "CopilotChat")
if status_chat then
	copilot_chat.setup({})
end
