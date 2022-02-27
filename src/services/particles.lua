local Object = require 'lib.classic'
local squeak = require 'lib.squeak'
local ParticlesComponent = squeak.components.particles
local images = require 'services.images'

local lg = love.graphics

local Particles = Object:extend()

function Particles:new() end

function Particles:dust()
  local DUST_COUNT = 3

  local ps = lg.newParticleSystem(images.image, DUST_COUNT)
  ps:setQuads({
    images:getQuad('dust1'),
  })
  -- ps:setOffset(2, 4)
  ps:setSizes(1)
  ps:setParticleLifetime(0, 1.5)
  ps:setEmitterLifetime(3)
  ps:setDirection(math.pi / 2)
  ps:setSpread(math.pi / 4)
  ps:setSpeed(5, 10)
  ps:setLinearAcceleration(0, 0, 0, 10)
  ps:setLinearDamping(1)
  ps:setColors(
    {1, 1, 1, 1},
    {1, 1, 1, 0}
  )
  ps:emit(DUST_COUNT)

  return ParticlesComponent(ps)
end

function Particles:__tostring()
  return 'Particles'
end

return Particles()
