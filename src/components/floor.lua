local squeak = require 'lib.squeak'
local Component = squeak.component
local config = require 'gameConfig'
local palette = require 'core.palette'

local lg = love.graphics

local Floor = Component:extend()

function Floor:new(x, y, w)
  Floor.super.new(self)
  self.x = x
  self.y = y
  self.w = w
  self.h = config.building.floorHeight
end

function Floor:draw()
  lg.push()
  palette.oak()
  local w, h = self.w, self.h
  lg.rectangle('line', self.x - w / 2, self.y - h / 2, w, h)
  lg.pop()
end

function Floor:__tostring()
  return 'Floor'
end

return Floor

