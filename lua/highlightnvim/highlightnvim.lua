local api = vim.api

local function get_word_under_cursor()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local line = api.nvim_get_current_line()
    local start, finish = col, col
    while start > 0 and line:sub(start, start):match('%w') do
        start = start - 1
    end
    while finish <= #line and line:sub(finish, finish):match('%w') do
        finish = finish + 1
    end
    return line:sub(start + 1, finish - 1)
end

local function highlight_word()
    local word = get_word_under_cursor()
    if word == '' then return end
    local pattern = '\\<' .. word .. '\\>'
    vim.cmd('match WordUnderCursor /' .. pattern .. '/')
end

api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
        highlight_word()
    end,
})

vim.cmd('hi WordUnderCursor cterm=underline gui=underline')
