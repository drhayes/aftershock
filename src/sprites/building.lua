local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local Floor = require 'components.floor'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local GROUND_HEIGHT = config.ground.height

local Building = GameObject:extend()

function Building:new(x, width, levels)
  Building.super.new(self, x, SCREEN_HEIGHT - GROUND_HEIGHT)
  self.width = width
  self.floors = {}

  local currentY = self.y - config.building.floorHeight / 2
  for i = 1, 5 do
    table.insert(self.floors, self:add(Floor(self.x, currentY, width)))
    currentY = currentY - config.building.floorHeight
  end
end

function Building:__tostring()
  return 'Building'
end

return Building


