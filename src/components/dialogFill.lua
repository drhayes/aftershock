local squeak = require 'lib.squeak'
local Component = squeak.component
local palette = require 'core.palette'
local config = require 'gameConfig'

local lg = love.graphics

local DialogFill = Component:extend()

function DialogFill:new()
  DialogFill.super.new(self)

  self.alpha = 1
end

function DialogFill:draw()
  local x = self.parent.x
  local y = self.parent.y
  local w = self.parent.width
  local h = self.parent.height

  palette.steel(self.alpha)
  lg.rectangle('fill', x, y, w, h)

  palette.iron(self.alpha)
  lg.setLineWidth(2)
  lg.rectangle('line', x, y, w, h)

  lg.setLineWidth(1)
  lg.rectangle('line', x+3, y+3, w-6, h-6)
end

function DialogFill:__tostring()
  return 'DialogFill'
end

return DialogFill

