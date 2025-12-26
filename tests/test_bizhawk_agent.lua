-- tests/test_bizhawk_agent.lua
-- luacheck: globals TestBizHawkAgent
-- Unit tests for bizhawk_ai_agent.lua using luaunit

-- 1. Setup Environment Mocks BEFORE requiring the script
TESTING_MODE = true

-- Mock luanet and System types
_G.luanet = {
    load_assembly = function(name) end,
    import_type = function(type_name)
        if type_name == "System.Net.Sockets.TcpClient" then
            return function()
                return {
                    Connect = function() end,
                    GetStream = function() end,
                    Close = function() end
                }
            end
        elseif type_name == "System.IO.File" then
            return { ReadAllBytes = function() end }
        elseif type_name == "System.Text.Encoding" then
            return { ASCII = { GetBytes = function() end, GetString = function() end } }
        elseif type_name == "System.Byte[]" then
            return function(size) return {} end
        end
        return {}
    end
}

-- Mock BizHawk globals
_G.console = {
    log = function(msg) end,
    clear = function() end
}

_G.client = {
    screenshot = function(filename) end
}

_G.gui = {
    drawText = function(x, y, text, color) end
}

_G.joypad = {
    set = function(inputs)
        _G.last_joypad_set = inputs -- Store for verification
    end
}

_G.emu = {
    frameadvance = function() end,
    getsystemid = function() return "NES" end
}

-- Load luaunit
local luaunit = require('tests.luaunit')

-- Load the agent script
local agent = require('bizhawk_ai_agent')

-- 2. Define Test Logic
TestBizHawkAgent = {}

function TestBizHawkAgent:setUp()
    _G.last_joypad_set = {}
    agent.set_console_type("NES") -- Default to NES for most tests
end

function TestBizHawkAgent:test_ExtractNumbers_Normal()
    local json = '{"buttons": [1, 0, 1], "other": "value"}'
    local result = agent.extract_numbers(json, "buttons")
    luaunit.assertEquals(#result, 3)
    luaunit.assertEquals(result[1], 1)
    luaunit.assertEquals(result[2], 0)
    luaunit.assertEquals(result[3], 1)
end

function TestBizHawkAgent:test_ExtractNumbers_Nested()
    local json = '{"data": {"buttons": [0.5, 1.0, -1]}}'
    local result = agent.extract_numbers(json, "buttons")
    luaunit.assertEquals(#result, 3)
    luaunit.assertEquals(result[1], 0.5)
    luaunit.assertEquals(result[2], 1.0)
    luaunit.assertEquals(result[3], -1)
end

function TestBizHawkAgent:test_ExtractNumbers_Empty()
    local json = '{"buttons": []}'
    local result = agent.extract_numbers(json, "buttons")
    luaunit.assertEquals(#result, 0)
end

function TestBizHawkAgent:test_ExtractNumbers_NotFound()
    local json = '{"foo": [1, 2, 3]}'
    local result = agent.extract_numbers(json, "bar")
    luaunit.assertEquals(type(result), "table")
    luaunit.assertEquals(#result, 0)
end

function TestBizHawkAgent:test_ApplyControls_NES_A_Button()
    agent.set_console_type("NES")

    -- Prepare a slice of 21 buttons (standard size supported by script)
    local btns = {}
    for i=1, 21 do btns[i] = 0 end

    -- Index 19 is 'A' for NES in the script logic: joy["P1 A"] = btn_slice[19] > 0.5
    btns[19] = 1.0

    local stick = {0, 0}

    agent.apply_controls_frame(btns, stick)

    local joy = _G.last_joypad_set
    luaunit.assertTrue(joy["P1 A"])
    luaunit.assertFalse(joy["P1 B"]) -- Index 6 should be 0
end

function TestBizHawkAgent:test_ApplyControls_SNES_ShoulderButtons()
    agent.set_console_type("SNES")

    local btns = {}
    for i=1, 21 do btns[i] = 0 end

    -- Index 8 is 'L', Index 15 is 'R' based on script logic
    -- joy["P1 L"] = btn_slice[8] > 0.5
    -- joy["P1 R"] = btn_slice[15] > 0.5
    btns[8] = 1.0
    btns[15] = 1.0

    local stick = {0, 0}

    agent.apply_controls_frame(btns, stick)

    local joy = _G.last_joypad_set
    luaunit.assertTrue(joy["P1 L"])
    luaunit.assertTrue(joy["P1 R"])
    luaunit.assertFalse(joy["P1 A"]) -- Should be nil or false depending on initialization, script sets it specific
end

function TestBizHawkAgent:test_ApplyControls_Stick_Threshold()
    agent.set_console_type("NES")
    local btns = {}
    for i=1, 21 do btns[i] = 0 end

    -- Stick Left: value < -0.5
    local stick_left = {-0.8, 0}
    agent.apply_controls_frame(btns, stick_left)
    luaunit.assertTrue(_G.last_joypad_set["P1 Left"])

    -- Stick Right: value > 0.5
    local stick_right = {0.6, 0}
    agent.apply_controls_frame(btns, stick_right)
    luaunit.assertTrue(_G.last_joypad_set["P1 Right"])

    -- Stick Center: value 0.1 (below threshold)
    local stick_center = {0.1, 0}
    agent.apply_controls_frame(btns, stick_center)
    luaunit.assertFalse(_G.last_joypad_set["P1 Right"])
    luaunit.assertFalse(_G.last_joypad_set["P1 Left"])
end

-- 3. Run Tests
os.exit(luaunit.LuaUnit.run("TestBizHawkAgent"))
