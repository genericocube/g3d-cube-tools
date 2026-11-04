-- g3d-cube-tools | feito por generico_cube
-- Menu para abrir as demos de cada ferramenta. Para usar só uma ferramenta no seu jogo,
-- copie a pasta/arquivo dela (veja o README) e ignore este main.lua e a pasta demos/.

local demos = {
    {key = "1", name = "g3d-iluminacao", info = "luz em tempo real + sombras", file = "demos/iluminacao/main.lua"},
    {key = "2", name = "som3d",          info = "áudio espacial 3D",           file = "demos/som3d/main.lua"},
    {key = "3", name = "g3d-glb",        info = "modelos .glb animados",       file = "demos/glb/main.lua"},
}

-- callbacks que cada demo pode definir, são limpos antes de abrir a demo escolhida
local callbackNames = {
    "load", "update", "draw", "keypressed", "keyreleased", "mousepressed", "mousereleased",
    "mousemoved", "wheelmoved", "textinput", "resize", "focus", "visible", "quit",
}

local function startDemo(demo)
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
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("g3d-cube-tools", 40, 40, 0, 2, 2)
    for i, demo in ipairs(demos) do
        love.graphics.print(("%s  -  %s  (%s)"):format(demo.key, demo.name, demo.info), 40, 70 + i * 30)
    end
    love.graphics.print("esc: sair   |   dentro de uma demo, F10 volta ao menu", 40, 80 + (#demos + 1) * 30)
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
