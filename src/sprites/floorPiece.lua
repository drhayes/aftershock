local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Image = require 'components.image'
local config = require 'gameConfig'
local tween = require 'lib.tween'

local GRAVITY = config.gravity

local FloorPiece = GameObject:extend()

function FloorPiece:new(buildingType, x, y)
  FloorPiece.super.new(self, x, y)

  self.image = self:add(Image('building' .. buildingType .. '-piece' .. love.math.random(1, 4)))
  self.velX = love.math.random(20, 40)
  if love.math.random() >= .5 then
    self.velX = -self.velX
  end
  self.velY = love.math.random(-40, -10)
  self.dr = self.velX / 10

  self.a = 1
  self.alphaTween = tween.new(config.building.pieceDuration, self, { a = 0 }, 'inCubic')
end

function FloorPiece:update(dt)
  FloorPiece.super.update(self, dt)

  self.velY = self.velY + GRAVITY * dt

  self.x = self.x + self.velX * dt
  self.y = self.y + self.velY * dt

  self.image.r = self.image.r + self.dr * dt
  self.image.alpha = self.a

  self.removeMe = self.alphaTween:update(dt)
end

function FloorPiece:__tostring()
  return 'FloorPiece'
end

return FloorPiece
