local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Animation = require 'components.animation'

local SmallExplosion = GameObject:extend()

function SmallExplosion:new(x, y)
  SmallExplosion.super.new(self, x, y)

  local anim = self:add(Animation('smallExplosion'))
  anim:setLoopCallback(function() self.removeMe = true end)
end


function SmallExplosion:__tostring()
  return 'SmallExplosion'
end

return SmallExplosion

