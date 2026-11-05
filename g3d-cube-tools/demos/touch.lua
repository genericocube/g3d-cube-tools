-- demos/touch.lua | controles de toque para testar as demos no celular | feito por generico_cube
-- Touch controls so the keyboard/mouse demos can be tried on a phone.
--
-- It translates on-screen controls into the keys and mouse movement the demos already use:
--   joystick -> W A S D      look pad -> love.mousemoved      buttons -> any key
-- Built with g3dui (the hub's own UI library). Only the hub uses this file.

local ui = require "g3d-cube-tools.g3dui"

local touch = {}

local held = {}          -- virtual keys currently down
local relative = false   -- virtual "relative mouse mode" (never captures the real cursor)
local installed = false

function touch.isMobile()
    local os = love.system.getOS()
    return os == "Android" or os == "iOS"
end

local function setKey(key, down)
    down = down and true or nil
    if held[key] == down then return end
    held[key] = down
    if down then
        if love.keypressed then love.keypressed(key, key, false) end
    else
        if love.keyreleased then love.keyreleased(key, key) end
    end
end

-- demos poll love.keyboard.isDown and love.mouse.getRelativeMode, so those are wrapped
local function install()
    if installed then return end
    installed = true

    local realIsDown = love.keyboard.isDown
    love.keyboard.isDown = function(...)
        for i = 1, select("#", ...) do
            if held[select(i, ...)] then return true end
        end
        return realIsDown(...)
    end

    love.mouse.setRelativeMode = function(v) relative = v and true or false end
    love.mouse.getRelativeMode = function() return relative end
end

local keyLabels = { left = "<", right = ">", up = "^", down = "v", backspace = "bksp" }

local function keyButton(key)
    return ui.button{
        text = keyLabels[key] or key, w = 72, h = 48,
        onPress = function() setKey(key, true) end,
        onRelease = function() setKey(key, false) end,
    }
end

-- cfg = { joystick = bool, look = bool, rise = bool, keys = { "f", "g", ... } }
function touch.start(cfg)
    install()
    relative = false

    ui.layer("touch", { order = -5, visible = true })     -- under the buttons, so they always win
    ui.layer("touchhud", { order = 0, visible = true })
    ui.layer("keys", { order = 10, visible = false })

    if cfg.joystick then
        ui.joystick{
            layer = "touch", name = "touch_move", anchor = "bottom-left", x = 40, y = 40, radius = 85,
            onChange = function(_, x, y)
                setKey("w", y < -0.4)
                setKey("s", y > 0.4)
                setKey("a", x < -0.4)
                setKey("d", x > 0.4)
            end,
        }
    end

    if cfg.look then
        ui.touchpad{
            layer = "touch", anchor = "right", w = "55%", h = "100%", z = -1, pickTaps = false,
            onPress = function() relative = true end,
            onDrag = function(_, dx, dy, p)
                local s = ui.layout.scale * 1.5 -- virtual units -> mouse-like pixels
                if love.mousemoved then love.mousemoved(p.px, p.py, dx * s, dy * s, true) end
            end,
        }
    end

    if cfg.rise then
        ui.button{
            layer = "touchhud", anchor = "bottom-right", x = 20, y = 130, w = 84, h = 84, text = "Up",
            onPress = function() setKey("space", true) end, onRelease = function() setKey("space", false) end,
        }
        ui.button{
            layer = "touchhud", anchor = "bottom-right", x = 20, y = 30, w = 84, h = 84, text = "Down",
            onPress = function() setKey("lshift", true) end, onRelease = function() setKey("lshift", false) end,
        }
    end

    ui.button{
        layer = "touchhud", anchor = "top-right", x = 12, y = 12, w = 96, h = 44, text = "Menu",
        onClick = function() love.event.quit("restart") end, -- same as F10
    }

    if cfg.keys and #cfg.keys > 0 then
        ui.button{
            layer = "touchhud", anchor = "top-right", x = 12, y = 64, w = 96, h = 44, text = "Keys",
            onClick = function() ui.toggleLayer("keys") end,
        }
        local rows = {}
        for i = 1, #cfg.keys, 3 do
            local row = {}
            for j = i, math.min(i + 2, #cfg.keys) do row[#row + 1] = keyButton(cfg.keys[j]) end
            rows[#rows + 1] = ui.panel{
                stack = "horizontal", spacing = 6, padding = 0, border = false,
                style = { bg = { 0, 0, 0, 0 } }, children = row,
            }
        end
        ui.panel{
            layer = "keys", anchor = "top-right", x = 12, y = 116, stack = "vertical", spacing = 6,
            padding = 8, children = rows,
        }
    end
end

return touch
