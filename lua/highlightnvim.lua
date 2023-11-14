local api = vim.api

local function should_skip_buffer()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")

    local skip_types = {
        ["nofile"] = true,
        ["terminal"] = true,
        ["prompt"] = true,
        ["help"] = true,
        ["quickfix"] = true,
        ["loclist"] = true,
    }

    return skip_types[buftype] or false
end
local function get_word_under_cursor()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()

    local start = col
    while start > 0 and line:sub(start, start):match("%w") do
        start = start - 1
    end
    local finish = col
    while finish <= #line and line:sub(finish + 1, finish + 1):match("%w") do
        finish = finish + 1
    end

    if start < finish then
        start = start + 1
    end

    return line:sub(start, finish)
end

local function highlight_word()
    local mode = api.nvim_get_mode().mode
    if mode ~= "n" then
        return
    end

    if should_skip_buffer() then
        vim.cmd("match none")
        return
    end

    local word = get_word_under_cursor()

    if word == "" or word:match("[^%w_]") then
        vim.cmd("match none")
        return
    end

    local pattern = "\\<" .. word .. "\\>"
    vim.cmd("match WordUnderCursor /" .. pattern .. "/")
end

api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
        highlight_word()
    end,
})

vim.cmd("hi WordUnderCursor cterm=underline gui=underline")
