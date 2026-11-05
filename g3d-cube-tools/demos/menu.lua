-- g3d-cube-tools | feito por generico_cube
-- Menu para abrir as demos de cada ferramenta. Para usar só uma ferramenta no seu jogo,
-- copie a pasta/arquivo dela (veja o README) e ignore este main.lua e a pasta demos/.

local ui = require "g3d-cube-tools.g3dui"
local touch = require "g3d-cube-tools.demos.touch"

-- No celular os controles de toque ligam sozinhos; no PC dá para testar com a opção do menu.
-- On a phone the touch controls turn on by themselves; on PC use the menu option to preview.
local touchEnabled = touch.isMobile()

-- touch = controles de toque da demo (false: a demo já tem os próprios controles de toque)
local demos = {
    {key = "1", name = "g3d-iluminacao", info = "luz em tempo real + sombras", file = "g3d-cube-tools/demos/iluminacao/main.lua",
     touch = {joystick = true, look = true, rise = true, keys = {"f", "g", "l", "t", "b", "v", "q", "h", "r", "left", "right"}}},
    {key = "2", name = "som3d",          info = "áudio espacial 3D",           file = "g3d-cube-tools/demos/som3d/main.lua",
     touch = {joystick = true, look = true, rise = true, keys = {"1", "2", "m", "f", "r", "backspace"}}},
    {key = "3", name = "g3d-glb",        info = "modelos .glb animados",       file = "g3d-cube-tools/demos/glb/main.lua",
     touch = {keys = {"1", "2", "3", "space", "up", "down", "s"}}},
    {key = "4", name = "g3d-interface-e-entrada", info = "UI, joystick, toque e clique em 3D", file = "g3d-cube-tools/demos/interface/main.lua", touch = false},
}

-- callbacks que cada demo pode definir, são limpos antes de abrir a demo escolhida
local callbackNames = {
    "load", "update", "draw", "keypressed", "keyreleased", "mousepressed", "mousereleased",
    "mousemoved", "wheelmoved", "textinput", "resize", "focus", "visible", "quit",
    "touchpressed", "touchreleased", "touchmoved", "gamepadpressed", "gamepadreleased", "gamepadaxis",
}

local function startDemo(demo)
    ui.destroyAll() -- remove os widgets do menu
    for _, name in ipairs(callbackNames) do love[name] = nil end
    love.graphics.setBackgroundColor(0, 0, 0, 1)

    assert(love.filesystem.load(demo.file))()

    -- F10 reinicia o programa e volta ao menu
    local innerKeypressed = love.keypressed
    love.keypressed = function(key, ...)
        if key == "f10" then
            love.event.quit("restart")
            return
        end
        if innerKeypressed then return innerKeypressed(key, ...) end
    end

    -- aviso discreto no canto da tela, desenhado por cima da demo
    local innerDraw = love.draw
    love.draw = function(...)
        if innerDraw then innerDraw(...) end
        love.graphics.push("all")
        love.graphics.origin()
        love.graphics.setShader()
        love.graphics.setCanvas()
        love.graphics.setDepthMode()
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.print("F10: menu", 8, love.graphics.getHeight() - 22)
        love.graphics.pop()
        love.graphics.setDepthMode("lequal", true)
    end

    if love.load then love.load() end

    -- controles de toque por cima da demo (a demo "interface" usa a própria UI)
    if demo.touch and touchEnabled then
        touch.start(demo.touch)
        local innerUpdate, drawWithHint = love.update, love.draw
        love.update = function(dt)
            ui.update(dt)
            if innerUpdate then innerUpdate(dt) end
        end
        love.draw = function(...)
            drawWithHint(...)
            ui.draw()
        end
    end
end

local function buildMenu()
    local items = {}
    for _, demo in ipairs(demos) do
        items[#items + 1] = ui.button{
            text = ("%s  -  %s  (%s)"):format(demo.key, demo.name, demo.info), w = 520, h = 56,
            onClick = function() love.keypressed(demo.key) end,
        }
    end
    items[#items + 1] = ui.toggle{
        text = "Controles de toque / Touch controls", value = touchEnabled,
        onChange = function(_, on) touchEnabled = on end,
    }
    items[#items + 1] = ui.button{ text = "Sair / Quit", w = 520, h = 48, onClick = function() love.event.quit() end }
    ui.panel{
        anchor = "center", title = "g3d-cube-tools", stack = "vertical", spacing = 10, padding = 18,
        children = items,
    }
end

function love.load()
    ui.setup()
    ui.hook() -- toque, mouse e teclado passam pela UI antes das demos
    buildMenu()
end

function love.update(dt)
    ui.update(dt)
end

function love.draw()
    ui.draw()
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.print("1-4: abrir demo   |   esc: sair   |   dentro de uma demo, F10 volta ao menu", 12, love.graphics.getHeight() - 24)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        return
    end
    for _, demo in ipairs(demos) do
        if key == demo.key then
            startDemo(demo)
            return
        end
    end
end
