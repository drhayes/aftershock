local squeak = require 'lib.squeak'
local Component = squeak.component
local config = require 'gameConfig'
local palette = require 'core.palette'
local lume = require 'lib.lume'

local lg = love.graphics
local DISTANCE_DAMAGE_THRESHOLD = config.building.damageDistanceThreshold
local DAMAGE_THRESHOLD = config.building.damageThreshold
local GRAVITY = config.gravity

local Floor = Component:extend()

function Floor:new(level, x, y, w)
  Floor.super.new(self)
  self.level = level
  self.x = x
  self.offsetX = 0
  self.offsetY = 0
  self.y = y
  self.w = w
  self.h = config.building.floorHeight
  self.velY = 0
  self.fallDistance = 0
  self.damage = 0
  self.damageThreshold = DAMAGE_THRESHOLD + math.random(-DAMAGE_THRESHOLD/3, DAMAGE_THRESHOLD/4)
  if self.level == 2 then self.damageThreshold = 1 end
end

function Floor:setDownstairs(downstairs)
  self.downstairs = downstairs
end

function Floor:update(dt)
  Floor.super.update(self, dt)
  local bottom = self.y + self.h/2

  if self.downstairs and self.downstairs.destroyed then
    -- TODO: Consider looping through till we find something.
    self.downstairs = self.downstairs.downstairs
  end

  local oldVelY = self.velY
  local velY = self.velY
  local dy = velY * dt

  local floor = self.parent.y
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
    self.damage = self.damage + self.fallDistance / 5
    -- Deliver damage to thing we hit.
    if self.downstairs and not self.downstairs.destroyed and self.downstairs.velY == 0 then
      self.downstairs.damage = self.downstairs.damage + self.fallDistance / 10
    end
    self.fallDistance = 0
  end

  if self.damage >= self.damageThreshold then
    self.destroyed = true
    self.removeMe = true
  end

  -- Don't do anything else if we're not quaking.
  if not self.parent.quaking then return end

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

function Floor:draw()
  local x = self.x + self.offsetX
  local y = self.y + self.offsetY
  local w, h = self.w, self.h
  local halfWidth = self.w/2
  local halfHeight = self.h/2

  lg.push()
  palette.ink()
  lg.rectangle('fill', x - halfWidth, y - halfHeight, w, h)
  palette.steel()
  lg.rectangle('fill', x - halfWidth - 4, y - halfHeight, w - 2, h)

  palette.white()
  lg.print(lume.round(self.damage, .2) .. '/' .. lume.round(self.damageThreshold, .2), self.x, self.y)
  lg.pop()
end

function Floor:__tostring()
  return 'Floor'
end

return Floor

