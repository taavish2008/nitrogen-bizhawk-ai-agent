std = "lua54"

-- Global variables provided by BizHawk or the script itself
globals = {
    "joypad",
    "console",
    "client",
    "gui",
    "emu",
    "TESTING_MODE",
    "luanet",
}

-- Ignore unused arguments in functions if they start with an underscore
unused_args = false

-- Exclude dependencies and vendored files
exclude_files = {
    ".luarocks/**",
    "tests/luaunit.lua"
}
