local squeak = require 'lib.squeak'
local Component = squeak.component
local config = require 'gameConfig'
local palette = require 'core.palette'

local lg = love.graphics

local Floor = Component:extend()

function Floor:new(level, x, y, w)
  Floor.super.new(self)
  self.level = level
  self.x = x
  self.offsetX = 0
  self.y = y
  self.w = w
  self.h = config.building.floorHeight
end

function Floor:draw()
  local x = self.x + self.offsetX
  local y = self.y
  local w, h = self.w, self.h
  local halfWidth = self.w/2
  local halfHeight = self.h/2

  lg.push()
  palette.ink()
  lg.rectangle('fill', x - halfWidth, y - halfHeight, w, h)
  palette.steel()
  lg.rectangle('fill', x - halfWidth - 4, y - halfHeight, w - 2, h)
  lg.pop()
end

function Floor:__tostring()
  return 'Floor'
end

return Floor

