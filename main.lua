local sti = require "library/sti"
local wf = require "library/windfield"

function love.load()
    world = wf.newWorld(0, 0)
    p = {}
    p.x = 0
    p.y = 16
    p.vx = 0
    p.vy = 0
    p.speed = 1
    p.bottompointx = p.x + 8
    p.bottompointy = p.y + 16
    p.grounded = false
    p.squid = false
    p.showsquid = true
    p.fast = false
    map = sti("maps/untitled.lua")
end

function love.update(dt)
    world:update(dt)
    p.bottompointx = p.x + 8
    p.bottompointy = p.y + 16
    if love.keyboard.isDown("right") then
        p.vx = p.speed
    elseif love.keyboard.isDown("left") then
        p.vx = -p.speed
    else
        p.vx = 0
    end
    if love.keyboard.isDown("space") and p.grounded then
        p.vy = -2

    end
    p.vy = p.vy + 0.05
    p.x = p.x + p.vx



    if p.grounded and not p.squid then
        p.speed = 1
    end

    

    print(p.speed)
    if map:getTileProperties('Tile Layer 1', math.floor(p.bottompointx / 16) + 1,
        (math.floor((p.bottompointy / 16) + 1)))["solid"] then
        p.vy = p.vy - (p.y / 16) * 16 + math.floor(p.y / 16) * 16
        p.y = math.floor(p.y / 16) * 16
        p.grounded = true
    else
        if p.fast then
            p.fast = true
        end
        p.grounded = false
    end

    if map:getTileProperties('Tile Layer 1', math.floor(p.bottompointx / 16) + 1,
    (math.floor((p.bottompointy / 16) + 1)))["inked"] and p.squid == true then
    p.speed = 2
    p.fast = true
    if p.grounded then
        p.showsquid = false
    end
end

if not map:getTileProperties('Tile Layer 1', math.floor(p.bottompointx / 16) + 1,
    (math.floor((p.bottompointy / 16) + 1)))["inked"] and p.squid == true and p.grounded then
    p.speed = 0.5
    p.showsquid = true
    end
    p.y = p.vy + p.y
    p.squid = love.keyboard.isDown('lshift')
    if love.keyboard.isDown("b") then
        print((p.x / 16))
        print(((p.y / 16)))
    end
    if love.keyboard.isDown("a") then
        print(map:getTileProperties('Tile Layer 1', math.floor((p.x / 16) + 1), (math.floor((p.y / 16) + 1)))["solid"])
    end
end

function love.draw()
    love.graphics.scale(2, 2)
    map:draw(0, 0, 2, 2)
    if p.squid == true and p.showsquid == true then
        love.graphics.rectangle('fill', p.x, p.y + 8, 16, 8)
    elseif p.showsquid == false and p.squid then
        love.graphics.rectangle('fill', p.x, p.y + 12, 16, 4)
    else
        love.graphics.rectangle('fill', p.x, p.y, 16, 16)
    end
    world:draw()
end
