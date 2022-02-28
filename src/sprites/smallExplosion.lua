local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Animation = require 'components.animation'
local sounds = require 'services.sounds'

local SmallExplosion = GameObject:extend()

function SmallExplosion:new(x, y)
  SmallExplosion.super.new(self, x, y)

  local anim = self:add(Animation('smallExplosion'))
  anim:setLoopCallback(function() self.removeMe = true end)
end

function SmallExplosion:gobAdded()
  sounds:play('smallExplosion', love.math.random(90, 110)/100)
end

function SmallExplosion:__tostring()
  return 'SmallExplosion'
end

return SmallExplosion

