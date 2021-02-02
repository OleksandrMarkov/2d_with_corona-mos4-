-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require ("physics") -- модуль фізики (для обробки зіткнень)
physics.start()

local background = display.newRect(160, 250, 350, 550)
-- 350х550 - розміри ігрового поля
-- початок поля: 160 від лівого краю, 250 - від верхнього 

background:setFillColor(0.5, 0.35, 0.93) -- фон

local hx = 160 -- висота чарунки
local hy = 0
for i=1, 26 do
  local myGrid = display.newRect(hx, hy, 350, 2)
  myGrid:setFillColor(0.5,0.5,0.5)
  hy = hy + 20
end

local vx = 20 -- ширина чарунки
local vy = 250
for i=1, 16 do
  local myGrid = display.newRect(vx, vy, 2, 550)
  myGrid:setFillColor(0.5,0.5,0.5)
  vx = vx + 20
end

-- перепони
local block_1 = display.newRect(280, 390, 40, 280)
local block_2 = display.newRect(280, 50, 40, 150)

local block_3 = display.newRect(400, 430, 40, 280)
local block_4 = display.newRect(400, 70, 40, 190)

local block_5 = display.newRect(520, 470, 40, 280)
local block_6 = display.newRect(520, 100, 40, 250)

local block_7 = display.newRect(640, 510, 40, 280)
local block_8 = display.newRect(640, 120, 40, 290)

-- герой
local hero = display.newRect(40, 200, 20, 20)
hero:setFillColor(0.4,0.2,0.3)

physics.addBody(hero) -- підключення фізики
hero.gravityScale = 0 -- гравітація не обробляється
hero.isFixedRotation = false -- обертання також
hero.isSensor = true -- обробляється зіткнення


-- вказуємо, що перепони статичні
physics.addBody(block_1, "static")
physics.addBody(block_2, "static")
physics.addBody(block_3, "static")
physics.addBody(block_4, "static")
physics.addBody(block_5, "static")
physics.addBody(block_6, "static")
physics.addBody(block_7, "static")
physics.addBody(block_8, "static")

-- id для об'єктів
hero.ID = "hero"
block_1.ID = "crash"
block_2.ID = "crash"
block_3.ID = "crash"
block_4.ID = "crash"
block_5.ID = "crash"
block_6.ID = "crash"
block_7.ID = "crash"
block_8.ID = "crash"

-- швидкості руху героя вгору/вниз
local move_down = 4 
local move_up = 0
local function hero_flies (event)
  if(event.phase == "began") then
    move_up = 13
  end
end

local speed = 0.7 -- швидкість, з якою "пролітають" перепони 

local function update_objects (event)
-- "рух" перепон
  block_1.x = block_1.x - speed
  block_2.x = block_1.x - speed

  block_3.x = block_3.x - speed
  block_4.x = block_3.x - speed

  block_5.x = block_5.x - speed
  block_6.x = block_5.x - speed

  block_7.x = block_7.x - speed
  block_8.x = block_7.x - speed

  if(block_1.x <= -20) then
    block_1.x = block_7.x + 120
  elseif(block_3.x <= -20) then
    block_3.x = block_1.x + 120
  elseif(block_5.x <= -20) then
    block_5.x = block_3.x + 120
  elseif(block_7.x <= -20) then
    block_7.x = block_5.x + 120
  end

  if(move_up > 0) then
    hero.y = hero.y - move_up --підйом
    move_up = move_up - 0.8
  end
  hero.y = hero.y + move_down -- падіння

-- гра завершується, якщо герой "вилетів" за межі ігрового поля 
  if(hero.y < 0) then
    finish()
  elseif(hero.y > 520) then
    finish()
  end
end

-- а також при зіткненні
local function when_collied (self, event)
  if(event.phase == "began") then
    if(self.ID == "hero" and event.other.ID == "crash") then
      finish()
    end
  end
end

-- при завершенні обробкаподій припиняється
function finish ()
  hero:removeEventListener("collision", hero)
  Runtime:removeEventListener("enterFrame", update_objects)
  background:removeEventListener("touch", hero_flies)
  local text = display.newText("Ви програли!", 160, 220, font, 48)
  text:setFillColor(0,0,0)
end

hero.collision = when_collied
hero:addEventListener("collision", hero)

--оновлення ігрового поля та торкання гравця до екрану
Runtime:addEventListener("enterFrame", update_objects)
background:addEventListener("touch", hero_flies)