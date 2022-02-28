local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Animation = require 'components.animation'
local sounds = require 'services.sounds'

local GroundShock = GameObject:extend()

function GroundShock:new(x, y)
  GroundShock.super.new(self, x, y)

  local anim = self:add(Animation('groundShock'))
  anim.y = anim.y - anim.h/2
  anim:setLoopCallback(function() self.removeMe = true end)
end

function GroundShock:gobAdded()
  sounds:play('groundShock')
end

function GroundShock:__tostring()
  return 'GroundShock'
end

return GroundShock


