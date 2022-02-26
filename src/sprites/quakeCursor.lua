local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local QUAKE_CURSOR_HEIGHT = config.ground.height
local MAX_CURSOR_SPEED = 140
local MIN_CURSOR_SPEED = 100

local QuakeCursor = GameObject:extend()

function QuakeCursor:new()
  QuakeCursor.super.new(self, 0, config.graphics.height - QUAKE_CURSOR_HEIGHT / 2)
  self.w, self.h = 4, QUAKE_CURSOR_HEIGHT
  self.dir = 1
  self.speed = 20
end

local lg = love.graphics

function QuakeCursor:update(dt)
  QuakeCursor.super.update(self, dt)

  self.x = self.x + self.speed * self.dir * dt
  if self.x < 0 then
    self.x = 0
    self.dir = 1
  end
  if self.x > SCREEN_WIDTH then
    self.x = SCREEN_WIDTH
    self.dir = -1
  end

  local xNormalized = self.x / SCREEN_WIDTH
  self.speed = math.sin(math.pi * xNormalized) * MAX_CURSOR_SPEED + MIN_CURSOR_SPEED
end

function QuakeCursor:draw()
  lg.push()
  palette.iiem()
  local w, h = self.w, self.h
  lg.rectangle('fill', self.x - w/2, self.y - h/2, w, h)
  lg.pop()
end


function QuakeCursor:__tostring()
  return 'QuakeCursor'
end

return QuakeCursor

