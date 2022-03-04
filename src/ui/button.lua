local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Text = require 'components.text'
local palette = require 'core.palette'

local Button = GameObject:extend()

function Button:new(text, x, y, callback, callbackArg)
  Button.super.new(self, x, y)

  self.width = 70
  self.height = 18

  self.text = self:add(Text(defaultFont, text))
  self.isFocused = false
  self.callback = callback
  self.callbackArg = callbackArg

  self.text.x = 2
  self.width = self.text.width + 4
  self.height = self.text.height + 2

  self:blur()
end

function Button:focus()
  self.isFocused = true
end

function Button:blur()
  self.isFocused = false
end

function Button:trigger()
  self.callback(self.callbackArg)
end

local lg = love.graphics
function Button:draw()
  Button.super.draw(self)
  local x,y,w,h = math.floor(self.x), math.floor(self.y), self.width, self.height
  local isFocused = self.isFocused

  lg.push()
  if isFocused then
    palette.aluminum()
  else
    palette.shade(.5)
  end
  lg.line(x, y+h, x+w, y+h)
  lg.line(x, y, x, y+h)

  if isFocused then
    palette.aluminum()
  else
    palette.iron(.5)
  end
  lg.line(x-1, y, x+w, y)
  lg.line(x+w, y, x+w, y+h-1)
  lg.pop()
end


function Button:__tostring()
  return 'Button'
end

return Button


