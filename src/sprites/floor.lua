local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local Image = require 'components.image'

local DISTANCE_DAMAGE_THRESHOLD = config.building.damageDistanceThreshold
local DAMAGE_THRESHOLD = config.building.damageThreshold
local GRAVITY = config.gravity

local Floor = GameObject:extend()

function Floor:new(building, level, x, y)
  Floor.super.new(self, x, y)

  self.building = building
  self.level = level
  self.floorImage = self:add(Image(self:getFloorFrameName()))
  self.x = x
  self.y = y
  self.w = self.floorImage.w
  self.h = self.floorImage.h
  self.offsetX = 0
  self.offsetY = 0
  self.velY = 0
  self.fallDistance = 0
  self.damage = 0
  self.damageThreshold = DAMAGE_THRESHOLD + math.random(-DAMAGE_THRESHOLD/3, DAMAGE_THRESHOLD/4)

end

function Floor:getFloorFrameName()
  local building = self.building
  if self.level == 1 then
    return 'building' .. building.buildingType .. '-base-nodamage'
  elseif self.level == self.building.levelsCount then
    return 'building' .. building.buildingType .. '-cap-nodamage'
  else
    return 'building' .. building.buildingType .. '-floor-nodamage'
  end
end

function Floor:setDownstairs(downstairs)
  self.downstairs = downstairs
end

function Floor:shock()
  local normalized = (self.level - 1) / (self.building.levelsCount - 1)
  self.damage = self.damage + config.building.shockDamage * (1 - normalized) * (1 - normalized)
end

function Floor:downstairsDamage(damage)
  self.damage = self.damage + damage
  if self.downstairs then
    self.downstairs:downstairsDamage(damage * config.building.downstairsDamageFactor)
  end
end

function Floor:firstNonDestroyedFloor()
  if not self.destroyed then return self end
  if self.downstairs then return self.downstairs:firstNonDestroyedFloor() end
  return nil
end

function Floor:update(dt)
  Floor.super.update(self, dt)

  local bottom = self.y + self.h/2

  self.floorImage.x = self.offsetX
  self.floorImage.y = self.offsetY

  if self.downstairs and self.downstairs.destroyed then
    self.downstairs = self.downstairs:firstNonDestroyedFloor()
  end

  local oldVelY = self.velY
  local velY = self.velY
  local dy = velY * dt

  local floor = self.building.y
  if self.downstairs then
    floor = self.downstairs.y - self.downstairs.h/2
  end

  -- Are we falling?
  if bottom < floor then
    velY = velY + GRAVITY * dt
  else
    velY = 0
  end

  if velY > 0 then
    self.fallDistance = self.fallDistance + dy
    self.y = self.y + dy
    self.velY = velY
    return
  end

  if velY == 0 and oldVelY > 0 then
    -- We hit something, take fall damage.
    self.damage = self.damage + self.fallDistance * config.building.fallDamageFactor
    -- Deliver damage to thing we hit.
    if self.downstairs and not self.downstairs.destroyed and self.downstairs.velY == 0 then
      self.downstairs:downstairsDamage(self.fallDistance * config.building.downstairsFallDamageFactor)
    end
    self.fallDistance = 0
  end

  if self.damage >= self.damageThreshold then
    self.destroyed = true
    self.removeMe = true
  end

  -- Don't do anything else if we're not quaking.
  if not self.building.quaking then return end

  local downstairs = self.downstairs

  if downstairs and bottom == floor then
    -- Compare my x to theirs. If they differ by too much, add damage.
    local myX = self.x + self.offsetX
    local downstairsX = downstairs.x + downstairs.offsetX

    local dist = math.abs(downstairsX - myX)
    if dist >= DISTANCE_DAMAGE_THRESHOLD then
      self.damage = self.damage + self.level * dt
    end
  end


end

function Floor:__tostring()
  return 'Floor'
end

return Floor

