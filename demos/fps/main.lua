-- FPS mobile prototype | feito por generico_cube
-- g3d + g3dui + g3d-iluminacao
local g3d = require("g3d")
local ui = require("g3dui")
local Lighting = require("g3d-iluminacao")

local camera = g3d.camera
local lighting, whiteTexture
local worldModels, solids = {}, {}
local player = { x = 0, y = 0, z = 0, vz = 0, radius = 0.34, height = 1.4 }
local yaw, pitch = 0, 0
local sensitivity, speed = 1, 6.5
local gravity, jumpForce = 22, 8.5
local isMobile = love.system.getOS() == "Android" or love.system.getOS() == "iOS"

local function clamp(v, a, b) return math.max(a, math.min(b, v)) end

local function makeBox(hx, hy, hz, color)
    local out = {}
    local faces = {
        {1, {{-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}}},
        {0.55, {{-1,-1,-1},{-1,1,-1},{1,1,-1},{1,-1,-1}}},
        {0.82, {{-1,-1,-1},{1,-1,-1},{1,-1,1},{-1,-1,1}}},
        {0.82, {{-1,1,-1},{-1,1,1},{1,1,1},{1,1,-1}}},
        {0.68, {{-1,-1,-1},{-1,-1,1},{-1,1,1},{-1,1,-1}}},
        {0.68, {{1,-1,-1},{1,1,-1},{1,1,1},{1,-1,1}}},
    }
    for _, face in ipairs(faces) do
        local shade, p = face[1], face[2]
        local function vertex(v)
            return {v[1]*hx,v[2]*hy,v[3]*hz, 0,0, 0,0,0,
                color[1]*shade,color[2]*shade,color[3]*shade,1}
        end
        out[#out+1],out[#out+2],out[#out+3] = vertex(p[1]),vertex(p[2]),vertex(p[3])
        out[#out+1],out[#out+2],out[#out+3] = vertex(p[1]),vertex(p[3]),vertex(p[4])
    end
    return out
end

local function makeCapsule(radius, straightHeight, color)
    local out, rings = {}, {}
    for i = 0, 8 do
        local a = -math.pi/2 + (math.pi/2)*(i/8)
        rings[#rings+1] = {radius*math.cos(a), radius + radius*math.sin(a)}
    end
    for i = 0, 8 do
        local a = (math.pi/2)*(i/8)
        rings[#rings+1] = {radius*math.cos(a), radius+straightHeight + radius*math.sin(a)}
    end
    local slices = 16
    for r = 1, #rings-1 do
        for s = 0, slices-1 do
            local a, b = s*math.pi*2/slices, (s+1)*math.pi*2/slices
            local function v(ring, angle)
                local rr, z = ring[1], ring[2]
                local x, y = math.cos(angle), math.sin(angle)
                return {rr*x,rr*y,z,0,0,x,y,0,color[1],color[2],color[3],1}
            end
            local a1,b1 = v(rings[r],a),v(rings[r],b)
            local a2,b2 = v(rings[r+1],a),v(rings[r+1],b)
            out[#out+1],out[#out+2],out[#out+3] = a1,b1,b2
            out[#out+1],out[#out+2],out[#out+3] = a1,b2,a2
        end
    end
    return out
end

local function addModel(vertices, x, y, z, options)
    local model = g3d.newModel(vertices, whiteTexture, {x,y,z})
    lighting:addModel(model, options or {})
    worldModels[#worldModels+1] = model
    return model
end

local function addSolid(x, y, hx, hy, hz, color)
    addModel(makeBox(hx,hy,hz,color), x,y,hz)
    solids[#solids+1] = {x=x,y=y,hx=hx,hy=hy}
end

local function buildWorld()
    addModel(makeBox(15,15,0.15,{0.22,0.28,0.32}),0,0,-0.15,{castsShadow=false})
    -- Limites da arena
    addSolid(0,-14.7,15,0.3,1.8,{0.28,0.36,0.43})
    addSolid(0,14.7,15,0.3,1.8,{0.28,0.36,0.43})
    addSolid(-14.7,0,0.3,15,1.8,{0.28,0.36,0.43})
    addSolid(14.7,0,0.3,15,1.8,{0.28,0.36,0.43})
    -- Obstáculos simples para testar colisão
    addSolid(3,2,1.4,1.4,1.2,{0.65,0.32,0.2})
    addSolid(-4,4,1.0,2.0,1.5,{0.2,0.42,0.65})
    addSolid(2,-5,2.0,0.8,0.9,{0.3,0.58,0.38})
    addSolid(-6,-3,1.0,1.0,1.8,{0.58,0.42,0.68})
end

local function collides(x, y)
    for _, b in ipairs(solids) do
        local cx = clamp(x, b.x-b.hx, b.x+b.hx)
        local cy = clamp(y, b.y-b.hy, b.y+b.hy)
        local dx, dy = x-cx, y-cy
        if dx*dx + dy*dy < player.radius*player.radius then return true end
    end
    return false
end

local function movePlayer(dx, dy)
    local nx = clamp(player.x+dx,-14.2,14.2)
    if not collides(nx,player.y) then player.x=nx end
    local ny = clamp(player.y+dy,-14.2,14.2)
    if not collides(player.x,ny) then player.y=ny end
end

local function updateCamera()
    local eye = player.z + 1.22
    camera.lookInDirection(player.x,player.y,eye,yaw,pitch)
end

local function buildUI()
    ui.layer("fps-touch",{order=-5,visible=isMobile})
    ui.layer("fps-hud",{order=0})
    ui.layer("fps-menu",{order=20,visible=false})

    ui.joystick{
        layer="fps-touch",name="move",anchor="bottom-left",
        x=42,y=38,radius=84,knobRadius=30
    }
    ui.touchpad{
        layer="fps-touch",delta="look",anchor="right",
        x=0,y=0,w="58%",h="100%",z=-2,showArea=false
    }
    ui.button{
        layer="fps-touch",text="PULAR",action="jump",
        anchor="bottom-right",x=48,y=42,w=112,h=112,
        draw=function(w)
            local cx,cy=w:getCenter()
            love.graphics.setColor(0.12,0.62,0.92,w.pressed and 0.9 or 0.62)
            love.graphics.circle("fill",cx,cy,w._w/2)
            love.graphics.setColor(1,1,1,0.95)
            love.graphics.setLineWidth(3)
            love.graphics.circle("line",cx,cy,w._w/2)
            ui.theme.print(w,"PULAR",w._x,cy-9,w._w,"center")
        end
    }
    ui.label{
        layer="fps-hud",anchor="top-left",x=18,y=14,shadow=true,
        text=function()
            return ("FPS: %d"):format(love.timer.getFPS())
        end
    }
    ui.button{
        layer="fps-hud",text="PAUSA",anchor="top-right",
        x=16,y=14,w=94,h=42,
        onClick=function() ui.toggleLayer("fps-menu") end
    }
    ui.panel{layer="fps-menu",w="100%",h="100%",border=false,
        style={bg={0,0,0,0.55}}}
    ui.panel{
        layer="fps-menu",anchor="center",title="PAUSADO",
        stack="vertical",spacing=10,padding=18,
        children={
            ui.label{text="Protótipo FPS • g3d-cube-tools"},
            ui.slider{w=230,min=0.4,max=2.0,value=1,
                onChange=function(_,v) sensitivity=v end},
            ui.label{text="Sensibilidade da câmera"},
            ui.button{text="CONTINUAR",w=230,onClick=function() ui.hideLayer("fps-menu") end},
            ui.button{text="REINICIAR",w=230,onClick=function()
                player.x,player.y,player.z,player.vz=0,0,0,0
                yaw,pitch=0,0
                ui.hideLayer("fps-menu")
            end},
        }
    }
end

function love.load()
    love.window.setTitle("FPS Mobile - g3d-cube-tools")
    love.graphics.setBackgroundColor(0.48,0.68,0.82)
    local imageData=love.image.newImageData(1,1)
    imageData:setPixel(0,0,1,1,1,1)
    whiteTexture=love.graphics.newImage(imageData)
    whiteTexture:setFilter("nearest","nearest")

    lighting=Lighting.new({
        quality="low",shadowsEnabled=false,
        directionalColor={0.9,0.94,1},directionalIntensity=0.8
    })
    lighting:setDirection(0.35,0.25,-0.9)
    lighting:setHemisphere({0.28,0.34,0.42},{0.12,0.13,0.15})

    ui.setup{camera=camera,theme="dark"}
    ui.hook()
    ui.bindAxis("move",{
        left={"key:a","key:left"},right={"key:d","key:right"},
        up={"key:w","key:up"},down={"key:s","key:down"},pad="left"
    })
    ui.bindAxis("look",{pad="right"})
    ui.bind("jump","key:space","pad:a")
    ui.bind("pause","key:escape","pad:start")

    buildWorld()
    -- Cápsula usada como corpo físico do jogador (não é desenhada para não bloquear a visão FPS).
    player.model=g3d.newModel(makeCapsule(player.radius,0.75,{0.22,0.58,0.92}),whiteTexture,{0,0,0})
    buildUI()
    updateCamera()
end

function love.update(dt)
    ui.update(dt)
    if ui.pressed("pause") then ui.toggleLayer("fps-menu") end
    if ui.isLayerVisible("fps-menu") then return end

    local dx,dy=ui.delta("look")
    local lx,ly=ui.axis("look")
    yaw=yaw-(dx*0.006+lx*dt*2.2)*sensitivity
    pitch=clamp(pitch-(dy*0.006+ly*dt*1.8)*sensitivity,-1.25,1.25)

    local ax,ay=ui.axis("move")
    local fx,fy=math.cos(yaw),math.sin(yaw)
    local rx,ry=-fy,fx
    local mx=fx*(-ay)+rx*ax
    local my=fy*(-ay)+ry*ax
    local length=math.sqrt(mx*mx+my*my)
    if length>1 then mx,my=mx/length,my/length end
    movePlayer(mx*speed*dt,my*speed*dt)

    if ui.pressed("jump") and player.z<=0.001 then player.vz=jumpForce end
    player.vz=player.vz-gravity*dt
    player.z=math.max(0,player.z+player.vz*dt)
    if player.z==0 then player.vz=0 end

    player.model:setTranslation(player.x,player.y,player.z)
    updateCamera()
end

function love.draw()
    love.graphics.clear(0.48,0.68,0.82,1)
    lighting:drawAll()
    ui.draw()
end

function love.resize(w,h)
    camera.resize(w,h)
end

function love.quit()
    if lighting then lighting:release() end
    if whiteTexture then whiteTexture:release() end
end
