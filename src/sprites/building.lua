local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local Floor = require 'components.floor'
local tween = require 'lib.tween'
local Coroutine = squeak.components.coroutine

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local GROUND_HEIGHT = config.ground.height
local FLOOR_HEIGHT = config.building.floorHeight

local Building = GameObject:extend()

function Building:new(x, width, levels)
  Building.super.new(self, x, SCREEN_HEIGHT - GROUND_HEIGHT)
  self.width = width
  self.floors = {}

  local currentY = self.y - FLOOR_HEIGHT / 2
  for i = 1, levels do
    table.insert(self.floors, self:add(Floor(i, self.x, currentY, width)))
    currentY = currentY - FLOOR_HEIGHT
  end
end

function Building:jump(power)
  local jumpHeight = 2
  self:add(Coroutine(function(co)

    -- Make the floors jump.
    local jump = { offset = 0 }
    local jumpTween = tween.new(.2, jump, { offset = jumpHeight }, 'outCirc')
    local complete = false
    while not complete do
      local _, dt = coroutine.yield()
      complete = jumpTween:update(dt)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.y = self.y - FLOOR_HEIGHT/2 - (FLOOR_HEIGHT * (i - 1)) - jump.offset * floor.level
      end
    end

    jumpTween = tween.new(.6, jump, { offset = 0 }, 'outBounce')
    complete = false
    while not complete do
      local _, dt = coroutine.yield()
      complete = jumpTween:update(dt)
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.y = self.y - FLOOR_HEIGHT/2 - (FLOOR_HEIGHT * (i - 1)) - jump.offset * floor.level
      end
    end

  end))
end

function Building:__tostring()
  return 'Building'
end

return Building


