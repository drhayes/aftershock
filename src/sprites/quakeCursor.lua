local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'

local lg = love.graphics
local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local MAX_CURSOR_SPEED = 240
local MIN_CURSOR_SPEED = 100

local QuakeCursor = GameObject:extend()

function QuakeCursor:new(y, width, height)
  QuakeCursor.super.new(self, 0, y)
  self.w, self.h = width, height
  self.dir = 1
  self.speed = 20

  self.quakePower = 10
end

function QuakeCursor:stop()
  self.oldDir = self.dir
  self.dir = 0
end

function QuakeCursor:restart()
  self.dir = self.oldDir or 1
end

function QuakeCursor:getPower(dist)
  -- TODO: Something cooler with distance attenuation.
  return self.quakePower
end

function QuakeCursor:update(dt)
  QuakeCursor.super.update(self, dt)

  self.x = self.x + self.speed * self.dir * dt
  if self.x < self.w then
    self.x = self.w
    self.dir = 1
  end
  if self.x > SCREEN_WIDTH - self.w then
    self.x = SCREEN_WIDTH - self.w
    self.dir = -1
  end

  local xNormalized = self.x / SCREEN_WIDTH
  self.speed = math.sin(math.pi * xNormalized) * MAX_CURSOR_SPEED + MIN_CURSOR_SPEED
end

function QuakeCursor:draw()
  lg.push()
  palette.iiem(.8)
  local w, h = self.w, self.h
  lg.rectangle('fill', self.x - w/2, self.y - h/2, w, h)
  lg.pop()
end


function QuakeCursor:__tostring()
  return 'QuakeCursor'
end

return QuakeCursor

