local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local Floor = require 'sprites.floor'
local tween = require 'lib.tween'
local Coroutine = squeak.components.coroutine
local lume = require 'lib.lume'

local SCREEN_HEIGHT = config.graphics.height
local GROUND_HEIGHT = config.ground.height
local FLOOR_HEIGHT = config.building.floorHeight
local JUMP_TIME = config.building.jumpTime
local SETTLE_TIME = config.building.settleTime

local Building = GameObject:extend()

function Building:new(buildingType, x, levels, gobs)
  Building.super.new(self, x, SCREEN_HEIGHT - GROUND_HEIGHT)

  self.buildingType = buildingType
  self.levelsCount = levels
  self.floors = {}

  local currentY = self.y - FLOOR_HEIGHT / 2
  local lastFloor = nil
  for i = 1, levels do
    local floor = gobs:add(Floor(self, i, self.x, currentY))
    self.width = floor.w
    table.insert(self.floors, floor)
    if lastFloor then
      floor:setDownstairs(lastFloor)
    end
    lastFloor = floor
    currentY = currentY - FLOOR_HEIGHT
  end
end

-- If the quake cursor was super close to the building deal extra damage.
function Building:shock()
  for i = 1, #self.floors do
    local floor = self.floors[i]
    floor:shock()
  end
end

-- Juicy jump animation for when cursor is triggered.
function Building:jump(power)
  local jumpHeight = 8 * power
  local rotMax = .25 * power

  self:add(Coroutine(function(co)

    for i = 1, #self.floors do
      local floor = self.floors[i]
      floor.rotDir = lume.sign(math.random(-1, 1))
    end

    -- Make the floors jump.
    local jump = { offset = 0, rotFactor = 0 }
    local jumpTween = tween.new(JUMP_TIME, jump, { offset = jumpHeight }, 'outCirc')
    local rotTween = tween.new(JUMP_TIME, jump, { rotFactor = rotMax }, 'outBounce')

    local complete = false
    while not complete do
      local _, dt = coroutine.yield()
      complete = jumpTween:update(dt)
      rotTween:update(dt)

      for i = 1, #self.floors do
        local floor = self.floors[i]
        -- floor.y = self.y - FLOOR_HEIGHT/2 - (FLOOR_HEIGHT * (i - 1)) - jump.offset * floor.level
        floor.offsetY = -jump.offset * floor.level
        floor.rotFactor = jump.rotFactor
      end
    end

    jumpTween = tween.new(SETTLE_TIME, jump, { offset = 0 }, 'outBounce')
    rotTween = tween.new(SETTLE_TIME, jump, { rotFactor = 0 }, 'outQuart')

    complete = false
    while not complete do
      local _, dt = coroutine.yield()
      complete = jumpTween:update(dt)
      rotTween:update(dt)

      for i = 1, #self.floors do
        local floor = self.floors[i]
        -- floor.y = self.y - FLOOR_HEIGHT/2 - (FLOOR_HEIGHT * (i - 1)) - jump.offset * floor.level
        floor.offsetY = -jump.offset * floor.level
        floor.rotFactor = jump.rotFactor
      end
    end

  end))
end

-- Actually runs the quake on all the floors.
function Building:quake(power)
  self:add(Coroutine(function(co)

    self.quaking = true
    local quakeSeconds = 8
    local soFar = 0
    while soFar <= quakeSeconds do
      local _, dt = coroutine.yield()
      for i = 1, #self.floors do
        local floor = self.floors[i]
        local currentPower = lume.lerp(1, power, soFar / (quakeSeconds - 2))
        floor.offsetX = math.sin(soFar * floor.level) * currentPower
      end
      soFar = soFar + dt
    end

    -- Fixup the offsets back to 0.
    soFar = 0
    while soFar <= 1 do
      for i = 1, #self.floors do
        local floor = self.floors[i]
        floor.offsetX = floor.offsetX * 0.9
      end
      local _, dt = coroutine.yield()
      soFar = soFar + dt
    end
    for i = 1, #self.floors do
      local floor = self.floors[i]
      floor.offsetX = 0
    end
    self.quaking = false

  end))
end

function Building:__tostring()
  return 'Building'
end

return Building


