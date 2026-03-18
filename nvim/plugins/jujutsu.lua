local status_lazyjj, lazyjj = pcall(require, "lazyjj")
if status_lazyjj then
    lazyjj.setup()
    vim.keymap.set("n", "<Leader>jj", "<cmd>LazyJJ<cr>", { desc = "Open LazyJJ" })
end

local status_hunk, hunk = pcall(require, "hunk")
if status_hunk then
    hunk.setup()
end

local status_jujutsu, jujutsu = pcall(require, "jujutsu")
if status_jujutsu then
    jujutsu.setup()
end