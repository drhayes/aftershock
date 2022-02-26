local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local Ground = require 'sprites.ground'
local config = require 'gameConfig'
local QuakeCursor = require 'sprites.quakeCursor'
local Building = require 'sprites.building'
local input = require 'services.input'
local lume = require 'lib.lume'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local lg = love.graphics

local Ingame = Scene:extend()

function Ingame:new(registry, eventBus)
  Ingame.super.new(self, registry, eventBus)

  eventBus:on('setGameScale', self.onSetGameScale, self)

  self.canvas = lg.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.gameScale = 1
  self.gobs = GobsList()

  self.gobs:add(Ground())
  self.firstCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 15, 20, 10))
  self.buildings = {}
  table.insert(self.buildings, self.gobs:add(Building(120, 40, 5)))
  table.insert(self.buildings, self.gobs:add(Building(200, 30, 7)))
end

function Ingame:update(dt)
  self.gobs:update(dt)

  input:update(dt)

  if input:isPressed('trigger') and not self.secondCursor then
    self.firstQuakeX = self.firstCursor.x
    self:cursorSelect(self.firstCursor)
    self.secondCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 5, 5, 10))
  elseif input:isPressed('trigger') and not self.alreadyQuaking then
    self.alreadyQuaking = true
    self.secondQuakeX = self.secondCursor.x
    self:cursorSelect(self.secondCursor)
  end
end


function Ingame:cursorSelect(cursor)
    cursor:stop()
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local dist = math.abs(building.x - cursor.x)
      local power = cursor:getPower(dist)
      building:jump(power)
    end
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
