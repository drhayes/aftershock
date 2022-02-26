local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local Ground = require 'sprites.ground'
local config = require 'gameConfig'
local QuakeCursor = require 'sprites.quakeCursor'
local Building = require 'sprites.building'
local input = require 'services.input'
local CoroutineList = squeak.coroutineList

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local lg = love.graphics

local Ingame = Scene:extend()

function Ingame:new(registry, eventBus)
  Ingame.super.new(self, registry, eventBus)

  eventBus:on('setGameScale', self.onSetGameScale, self)

  self.canvas = lg.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.gameScale = 1
  self.gobs = GobsList()
  self.coroutines = CoroutineList()

  self.gobs:add(Ground())
  self.firstCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 15, 20, 10))
  self.buildings = {}
  table.insert(self.buildings, self.gobs:add(Building(120, 40, 5)))
  table.insert(self.buildings, self.gobs:add(Building(200, 30, 7)))
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
      local quake = math.pow(first * second, overlap + 1)
      log.debug(first, second, overlap, quake)
      building:quake(quake * 4)
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

function Ingame:__tostring()
  return 'Ingame'
end

return Ingame
