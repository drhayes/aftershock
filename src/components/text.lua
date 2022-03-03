local squeak = require 'lib.squeak'
local Component = squeak.component
local palette = require 'core.palette'
local config = require 'gameConfig'

local lg = love.graphics

local Text = Component:extend()

function Text:new(font, text, x, y, maxWidth, align)
  Text.super.new(self)

  maxWidth = maxWidth or config.graphics.width
  align = align or 'left'

  self.text = lg.newText(font)
  self.text:setf({
    {1, 1, 1, 1},
    text,
  }, maxWidth, align)
  self.x = x or 0
  self.y = y or 0
  self.width, self.height = self.text:getDimensions()
  self.alpha = 1
  self:setPaletteColor('white')
end

function Text:setPaletteColor(paletteColor)
  self.paletteColor = paletteColor
end

function Text:draw()
  local x = self.parent.x + self.x
  local y = self.parent.y + self.y
  lg.push()
  palette[self.paletteColor](self.alpha)
  lg.draw(self.text, x, y)
  lg.pop()
end

function Text:__tostring()
  return 'Text'
end

return Text
