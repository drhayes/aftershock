local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Image = require 'components.image'
local Text = require 'components.text'
local palette = require 'core.palette'

local Button = GameObject:extend()

function Button:new(text, x, y, callback, callbackArg)
  Button.super.new(self, x, y)

  self.width = 70
  self.height = 18

  self.text = self:add(Text(defaultFont, text))
  self.leftFocusMarker = self:add(Image('leftFocusMarker'))
  self.rightFocusMarker = self:add(Image('rightFocusMarker'))
  self.callback = callback
  self.callbackArg = callbackArg

  -- Layout the components relative to each other.
  self.leftFocusMarker.x = self.leftFocusMarker.w/2
  self.leftFocusMarker.y = self.text.height/2 + 2
  self.rightFocusMarker.y = self.text.height/2 + 2
  self.text.x = self.leftFocusMarker.w + 2
  self.rightFocusMarker.x = self.text.x + self.text.width + 2

  self.width = self.leftFocusMarker.w + 2 + self.text.width + 2 + self.rightFocusMarker.w
  self.height = self.text.height + 2


  -- Turn off focus markers for now.
  self:blur()
end

function Button:focus()
  self.leftFocusMarker.active = true
  self.rightFocusMarker.active = true
end

function Button:blur()
  self.leftFocusMarker.active = false
  self.rightFocusMarker.active = false
end

function Button:trigger()
  self.callback(self.callbackArg)
end


function Button:__tostring()
  return 'Button'
end

return Button


