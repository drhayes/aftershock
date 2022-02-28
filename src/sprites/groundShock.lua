local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Animation = require 'components.animation'

local GroundShock = GameObject:extend()

function GroundShock:new(x, y)
  GroundShock.g.super.new(self, x, y)

  local anim = self:add(Animation('groundShock'))
  anim:setLoopCallback(function() self.removeMe = true end)
end


function GroundShock:__tostring()
  return 'GroundShock'
end

return GroundShock


