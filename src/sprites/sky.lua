local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local palette = require 'core.palette'
local config = require 'gameConfig'

local Sky = GameObject:extend()

function Sky:new()
  Sky.super.new(self, 0, 0)
  self.w, self.h = config.graphics.width, config.graphics.height
end

local lg = love.graphics

function Sky:draw()
  lg.push()
  palette.ink()
  lg.rectangle('fill', self.x, self.y, self.w, self.h)
  lg.pop()
end


function Sky:__tostring()
  return 'Sky'
end

return Sky

