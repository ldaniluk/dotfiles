local status_dark, dark_notify = pcall(require, "dark_notify")
if status_dark then
	dark_notify.run({
		schemes = {
			dark = { colorscheme = "base16-tomorrow-night-eighties" },
			light = { colorscheme = "base16-equilibrium-light" },
		},
	})
end

local status_bufferline, bufferline = pcall(require, "bufferline")
if status_bufferline then
	bufferline.setup()
end

local status_lualine, lualine = pcall(require, "lualine")
if status_lualine then
	lualine.setup({
		sections = {
			lualine_c = { "filename", "aerial" },
		},
	})
end
