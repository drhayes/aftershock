local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Image = require 'components.image'
local Text = require 'components.text'

local Button = GameObject:extend()

function Button:new(text, x, y, callback, callbackArg)
  Button.super.new(self, x, y)

  self.text = self:add(Text(defaultFont, text))
  self.leftFocusMarker = self:add(Image('focusMarker'))
  self.rightFocusMarker = self:add(Image('focusMarker'))
  self.callback = callback
  self.callbackArg = callbackArg

  -- Layout the components relative to each other.
  self.text.x = self.leftFocusMarker.w + 2
  self.rightFocusMarker.x = self.text.y + self.text.width + 2
  self.rightFocusMarker.sx = -1

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

function Button:__tostring()
  return 'Button'
end

return Button


