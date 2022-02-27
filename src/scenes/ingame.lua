local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local Ground = require 'sprites.ground'
local config = require 'gameConfig'
local QuakeCursor = require 'sprites.quakeCursor'
local Building = require 'sprites.building'
local input = require 'services.input'
local CoroutineList = squeak.coroutineList
local Dust = require 'sprites.dust'
local SmallExplosion = require 'sprites.smallExplosion'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local lg = love.graphics

local Ingame = Scene:extend()

function Ingame:new(registry, eventBus)
  Ingame.super.new(self, registry, eventBus)

  eventBus:on('setGameScale', self.onSetGameScale, self)

  self:subscribe('floorDamage', self.onFloorDamage, self)
  self:subscribe('floorDestroyed', self.onFloorDestroyed, self)

  self.canvas = lg.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.gameScale = 1
  self.gobs = GobsList()
  self.coroutines = CoroutineList()
end

function Ingame:enter()
  Ingame.super.enter(self)

  self.gobs:add(Ground())
  self.firstCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 15, 20, 10))
  self.buildings = {}
  table.insert(self.buildings, self.gobs:add(Building(1, 120, 8, self.gobs)))
  table.insert(self.buildings, self.gobs:add(Building(2, 200, 12, self.gobs)))
end

function Ingame:update(dt)
  self.gobs:update(dt)
  self.coroutines:update(dt)

  input:update(dt)

  if input:isPressed('trigger') and not self.secondCursor then
    self.firstQuakeX = self.firstCursor.x
    local cursor = self.firstCursor
    cursor:stop()
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local power = cursor:getPower(building.x)
      if power >= config.building.shockPowerThreshold then
        building:shock()
      end
      building:jump(power)
    end
    self.secondCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 5, 5, 10))

  elseif input:isPressed('trigger') and not self.alreadyQuaking then
    self.alreadyQuaking = true
    self.secondQuakeX = self.secondCursor.x
    local cursor = self.secondCursor
    cursor:stop()
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local power = cursor:getPower(building.x)
      if power >= config.building.shockPowerThreshold then
        building:shock()
      end
      building:jump(power)
    end
    self:startQuake()
  end
end


function Ingame:startQuake()
  self.coroutines:add(function(co)
    co:wait(1)
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local first = self.firstCursor:getPower(building.x)
      local second = self.secondCursor:getPower(building.x)
      -- Did second cursor land within first?
      local overlap = self.firstCursor:cursorOverlap(self.secondCursor)
      local powerConstant = 2
      local quake = first * powerConstant + second * powerConstant + overlap * powerConstant
      building:quake(quake)
    end
  end)
end


function Ingame:draw()
  -- Draw to tiny canvas.
  lg.setCanvas(self.canvas)
  lg.setScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  lg.push()
  lg.clear()

  self.gobs:draw()

  lg.pop()
  lg.setScissor()
  lg.setCanvas()

  -- Now draw to scaled canvas.
  lg.push()
  lg.setColor(1, 1, 1, 1)
  lg.draw(self.canvas, 0, 0, 0, self.gameScale)
  lg.pop()

end

function Ingame:onSetGameScale(gameScale)
  self.gameScale = gameScale
end

function Ingame:onFloorDamage(_, x, y)
  local ox = love.math.random(x - 20, x + 20)
  local oy = love.math.random(y - 5, y + 5)
  self.gobs:add(Dust(ox, oy))
end

function Ingame:onFloorDestroyed(x, y)
  self.gobs:add(SmallExplosion(x, y))
end

function Ingame:__tostring()
  return 'Ingame'
end

return Ingame
