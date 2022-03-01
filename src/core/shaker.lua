local Object = require 'lib.classic'

local Shaker = Object:extend()

function Shaker:new(maxOffset, maxAngle, chaosFactor)
  self.maxOffset = maxOffset
  self.maxAngle = maxAngle
  self.chaosFactor = chaosFactor
  self.chaos = 0
  self.noiseFactor = 0
end

function Shaker:update(dt)
  self.noiseFactor = self.noiseFactor + dt
  self.chaos = math.max(0, self.chaos + dt * -self.chaosFactor)
end

function Shaker:get(x, y, r)
  local shake = self.chaos * self.chaos
  local maxOffset = self.maxOffset
  local maxAngle = self.maxAngle

  x = x - maxOffset / 2 * shake + maxOffset * shake * love.math.noise(self.noiseFactor * 10)
  y = y - maxOffset / 2 * shake + maxOffset * shake * love.math.noise(self.noiseFactor * 11)
  r = r - maxAngle / 2 * shake + maxAngle * shake * love.math.noise(self.noiseFactor * 12)

  return x, y, r
end

function Shaker:add(newChaos, threshold)
  -- If a threshold if passed, then don't let this add go past the threshold.
  -- If a threshold is passed and it's already past this level, don't add it.
  -- For shakes that shouldn't be additive with each other.
  if threshold and self.chaos < threshold then
    self.chaos = math.min(threshold, self.chaos + newChaos)
  elseif not threshold then
    self.chaos = math.min(1, self.chaos + newChaos)
  end
end

function Shaker:__tostring()
  return 'Shaker'
end

return Shaker
