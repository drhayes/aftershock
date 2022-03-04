local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
-- local palette = require 'core.palette'
local config = require 'gameConfig'
local Image = require 'components.image'

local Sky = GameObject:extend()

function Sky:new()
  Sky.super.new(self, 0, 0)
  self.w, self.h = config.graphics.width, config.graphics.height
  local skyImage = self:add(Image('sky'))
  skyImage.x, skyImage.y = config.graphics.width/4, config.graphics.height/4
  skyImage.sx, skyImage.sy = 2, 2
  skyImage.alpha = 0.8
end

function Sky:__tostring()
  return 'Sky'
end

return Sky

