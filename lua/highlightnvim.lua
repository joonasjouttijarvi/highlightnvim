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

local function escape_pattern(text)
    return text:gsub('([^%w{}])', '\\%1'):gsub('([{}])', '\\%1')
end


local function get_word_under_cursor()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local line = api.nvim_get_current_line()
    local start, finish = col, col

    while start > 0 and line:sub(start, start):match("%w") do
        start = start - 1
    end
    while finish <= #line and line:sub(finish, finish):match("%w") do
        finish = finish + 1
    end

    local word = line:sub(start + 1, finish - 1)
    return word:match("^%s*$") and "" or word -- Check for blank space
end

local function highlight_word()
    if should_skip_buffer() then
        return
    end
    local word = get_word_under_cursor()

    if word == "" then
        vim.cmd("match none") -- Clear the highlight if the word is empty
        return
    end

    local escaped_word = escape_pattern(word)
    local pattern = "\\<" .. escaped_word .. "\\>"
    vim.cmd("match WordUnderCursor /" .. pattern .. "/")
end

api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
        highlight_word()
    end,
})

vim.cmd("hi WordUnderCursor cterm=underline gui=underline")
