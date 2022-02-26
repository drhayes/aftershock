local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'

local GROUND_HEIGHT = config.ground.height

local Ground = GameObject:extend()

function Ground:new()
  Ground.super.new(self, 0, config.graphics.height - GROUND_HEIGHT)
  self.w, self.h = config.graphics.width, GROUND_HEIGHT
end

local lg = love.graphics

function Ground:draw()
  lg.push()
  palette.flora()
  lg.rectangle('fill', self.x, self.y, self.w, self.h)
  lg.pop()
end


function Ground:__tostring()
  return 'Ground'
end

return Ground
