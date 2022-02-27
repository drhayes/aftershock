local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local particles = require 'services.particles'
local Timer = squeak.components.timer

local Dust = GameObject:extend()

function Dust:new(x, y)
  Dust.super.new(self, x, y)

  local dustThings = self:add(particles:dust())
  self:add(Timer(dustThings.ps:getEmitterLifetime(), self.onTimer, self))
end

function Dust:onTimer()
  self.removeMe = true
end


function Dust:__tostring()
  return 'Dust'
end

return Dust
