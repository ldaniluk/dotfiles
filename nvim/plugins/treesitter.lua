local status_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
if status_ts then
    ts_configs.setup({
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    })
end