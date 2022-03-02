local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local Ground = require 'sprites.ground'
local config = require 'gameConfig'
local QuakeCursor = require 'sprites.quakeCursor'
local Building = require 'sprites.building'
local input = require 'services.input'
local CoroutineList = squeak.coroutineList
local Dust = require 'sprites.dust'
local SmallExplosion = require 'sprites.smallExplosion'
local Shaker = require 'core.shaker'
local FloorPiece = require 'sprites.floorPiece'
local sounds = require 'services.sounds'
local GroundShock = require 'sprites.groundShock'
local Sky = require 'sprites.sky'
local LevelCard = require 'ui.levelCard'
local ResultCard = require 'ui.resultCard'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local lg = love.graphics

local Ingame = Scene:extend()

function Ingame:new(registry, eventBus)
  Ingame.super.new(self, registry, eventBus)

  eventBus:on('setGameScale', self.onSetGameScale, self)

  self:subscribe('floorDamage', self.onFloorDamage, self)
  self:subscribe('floorDestroyed', self.onFloorDestroyed, self)

  self.canvas = lg.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.gameScale = 1
  self.gobs = GobsList()
  self.coroutines = CoroutineList()
  self.shaker = Shaker(50, math.pi/12, 1)
end

function Ingame:enter(level)
  Ingame.super.enter(self)

  self.gobs:add(Sky())
  self.gobs:add(Ground())

  self.buildings = {}
  for i = 1, #level.buildings do
    local building = level.buildings[i]
    table.insert(self.buildings, self.gobs:add(Building(
      building.type,
      building.xPos,
      building.height,
      self.gobs
    )))
  end

  self.levelCard = self.gobs:add(LevelCard(level.title, level.instructions))

  self.winCondition = level.winCondition
end

function Ingame:update(dt)
  self.gobs:update(dt)
  self.coroutines:update(dt)
  self.shaker:update(dt)

  input:update(dt)

  -- Check our win condition.
  if self.startedQuake and self.finishedQuake and not self.evaluatedWinCondition then
    local theyWon = self.winCondition(self.gobs)
    self.evaluatedWinCondition = true
    if theyWon then
      self.gobs:add(ResultCard([[You've won!]], 'Congratulations!!!'))
    else
      self.gobs:add(ResultCard([[You've lost!]], [[That's poopy, try again.]]))
    end
  end

  if input:isPressed('trigger') and not self.levelCard.isFading then
    self.levelCard:fade()
    self.firstCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 15, 20, 10))

  elseif input:isPressed('trigger') and not self.secondCursor then
    self.firstQuakeX = self.firstCursor.x
    local cursor = self.firstCursor
    cursor:stop()
    sounds:play('quakeCursor')
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local power = cursor:getPower(building.x)
      if power >= config.building.shockPowerThreshold then
        self.gobs:add(GroundShock(building.x, building.y))
        building:shock()
      end
      building:jump(power)
    end
    self.secondCursor = self.gobs:add(QuakeCursor(SCREEN_HEIGHT - 5, 5, 10))

  elseif input:isPressed('trigger') and not self.startedQuake then
    self.startedQuake = true
    self.secondQuakeX = self.secondCursor.x
    local cursor = self.secondCursor
    cursor:stop()
    sounds:play('quakeCursor')
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local power = cursor:getPower(building.x)
      if power >= config.building.shockPowerThreshold then
        self.gobs:add(GroundShock(building.x, building.y))
        building:shock()
      end
      building:jump(power)
    end
    self:startQuake()
  end
end


function Ingame:startQuake()
  self.coroutines:add(function(co)
    self.finishedQuake = false

    co:wait(1)

    local quakeSound = sounds:play('quake')
    for i = 1, #self.buildings do
      local building = self.buildings[i]
      local first = self.firstCursor:getPower(building.x)
      local second = self.secondCursor:getPower(building.x)
      -- Did second cursor land within first?
      local overlap = self.firstCursor:cursorOverlap(self.secondCursor)
      local powerConstant = 2
      local quake = first * powerConstant + second * powerConstant + overlap * powerConstant
      building:quake(quake)
    end

    while not quakeSound:isStopped() do
      self.shaker:add(.02, .15)
      coroutine.yield()
    end

    self.finishedQuake = true
    log.debug('Quake finished!')
  end)
end


function Ingame:draw()
  -- Draw to tiny canvas.
  lg.setCanvas(self.canvas)
  lg.setScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  lg.push()
  lg.clear()

  self.gobs:draw()

  lg.pop()
  lg.setScissor()
  lg.setCanvas()

  -- Now draw to scaled canvas.
  lg.push()
  lg.setColor(1, 1, 1, 1)
  local x, y, r = self.shaker:get(0, 0, 0)
  lg.draw(self.canvas, x, y, r, self.gameScale)
  lg.pop()

end

function Ingame:onSetGameScale(gameScale)
  self.gameScale = gameScale
end

function Ingame:onFloorDamage(damage, x, y)
  local ox = love.math.random(x - 20, x + 20)
  local oy = love.math.random(y - 5, y + 5)
  self.gobs:add(Dust(ox, oy))
end

function Ingame:onFloorDestroyed(x, y, buildingType)
  -- Kaboom.
  self.gobs:add(SmallExplosion(
    love.math.random(x-5, x+5),
    love.math.random(y-2, y+4)
  ))
  -- Add some shake.
  self.shaker:add(.2)
  -- Add some debris.
  for i = 1, love.math.random(3, 6) do
    local ox = love.math.randomNormal(1.5, x)
    local oy = love.math.randomNormal(1, y)
    self.gobs:add(FloorPiece(buildingType, ox, oy))
  end
end

function Ingame:__tostring()
  return 'Ingame'
end

return Ingame
