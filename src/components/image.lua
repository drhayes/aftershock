local squeak = require 'lib.squeak'
local Component = squeak.component
local images = require 'services.images'

local lg = love.graphics

local Image = Component:extend()

function Image:new(frameName, x, y)
  Image.super.new(self)

  x = x or 0
  y = y or 0

  self.quad = images:getQuad(frameName)
  self.x = x
  self.y = y
  self.r = 0
  self.w, self.h = images:getSize(frameName)
end

function Image:draw()
  local parent = self.parent

  local x = self.x + parent.x - self.w/2
  local y = self.y + parent.y - self.h/2

  lg.push()
  lg.setColor(1, 1, 1)
  lg.draw(images.image, self.quad, x, y, self.r)
  lg.pop()
end

function Image:__tostring()
  return 'Image'
end

return Image
