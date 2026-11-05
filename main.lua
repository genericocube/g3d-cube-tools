-- g3d-cube-tools | feito por generico_cube
-- Menu para abrir as demos de cada ferramenta. Para usar só uma ferramenta no seu jogo,
-- copie a pasta/arquivo dela (veja o README) e ignore este main.lua e a pasta demos/.
local ui = require("g3dui")
local touch = require("demos.touch")
local touchEnabled = touch.isMobile()

local demos = {
    {key="1",name="g3d-iluminacao",info="luz em tempo real + sombras",file="demos/iluminacao/main.lua",
     touch={joystick=true,look=true,rise=true,keys={"f","g","l","t","b","v","q","h","r","left","right"}}},
    {key="2",name="som3d",info="áudio espacial 3D",file="demos/som3d/main.lua",
     touch={joystick=true,look=true,rise=true,keys={"1","2","m","f","r","backspace"}}},
    {key="3",name="g3d-glb",info="modelos .glb animados",file="demos/glb/main.lua",
     touch={keys={"1","2","3","space","up","down","s"}}},
    {key="4",name="g3d-interface-e-entrada",info="UI, joystick, toque e clique em 3D",file="demos/interface/main.lua",touch=false},
    {key="5",name="FPS Mobile",info="joystick, câmera touch, pulo e colisões",file="demos/fps/main.lua",touch=false},
}

local callbackNames={
    "load","update","draw","keypressed","keyreleased","mousepressed","mousereleased",
    "mousemoved","wheelmoved","textinput","resize","focus","visible","quit",
    "touchpressed","touchreleased","touchmoved","gamepadpressed","gamepadreleased","gamepadaxis",
}

local function startDemo(demo)
    ui.destroyAll()
    for _,name in ipairs(callbackNames) do love[name]=nil end
    love.graphics.setBackgroundColor(0,0,0,1)
    assert(love.filesystem.load(demo.file))()

    local innerKeypressed=love.keypressed
    love.keypressed=function(key,...)
        if key=="f10" then love.event.quit("restart"); return end
        if innerKeypressed then return innerKeypressed(key,...) end
    end

    local innerDraw=love.draw
    love.draw=function(...)
        if innerDraw then innerDraw(...) end
        love.graphics.push("all")
        love.graphics.origin()
        love.graphics.setShader()
        love.graphics.setCanvas()
        love.graphics.setDepthMode()
        love.graphics.setColor(1,1,1,0.6)
        love.graphics.print("F10: menu",8,love.graphics.getHeight()-22)
        love.graphics.pop()
        love.graphics.setDepthMode("lequal",true)
    end
    if love.load then love.load() end

    if demo.touch and touchEnabled then
        touch.start(demo.touch)
        local innerUpdate,drawWithHint=love.update,love.draw
        love.update=function(dt) ui.update(dt); if innerUpdate then innerUpdate(dt) end end
        love.draw=function(...) drawWithHint(...); ui.draw() end
    end
end

local function buildMenu()
    local items={}
    for _,demo in ipairs(demos) do
        items[#items+1]=ui.button{
            text=("%s  -  %s  (%s)"):format(demo.key,demo.name,demo.info),w=540,h=56,
            onClick=function() love.keypressed(demo.key) end
        }
    end
    items[#items+1]=ui.toggle{
        text="Controles de toque / Touch controls",value=touchEnabled,
        onChange=function(_,on) touchEnabled=on end
    }
    items[#items+1]=ui.button{text="Sair / Quit",w=540,h=48,onClick=function() love.event.quit() end}
    ui.panel{anchor="center",title="g3d-cube-tools",stack="vertical",spacing=10,padding=18,children=items}
end

function love.load()
    ui.setup()
    ui.hook()
    buildMenu()
end
function love.update(dt) ui.update(dt) end
function love.draw()
    ui.draw()
    love.graphics.setColor(1,1,1,0.6)
    love.graphics.print("1-5: abrir demo   |   esc: sair   |   dentro de uma demo, F10 volta ao menu",12,love.graphics.getHeight()-24)
end
function love.keypressed(key)
    if key=="escape" then love.event.quit(); return end
    for _,demo in ipairs(demos) do
        if key==demo.key then startDemo(demo); return end
    end
end
