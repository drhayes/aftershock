local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local ResultCard = require 'ui.resultCard'
local Button = require 'ui.button'
local UIContext = require 'ui.context'
local levels = require 'levels'
local config = require 'gameConfig'

local YouLost = Scene:extend()

function YouLost:new(registry, eventBus)
  YouLost.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()
  self.uiContext = UIContext()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function YouLost:enter()
  YouLost.super.enter(self)

  self.gobs:clear()
  self.uiContext:clear()

  local resultCard = self.gobs:add(ResultCard([[You lost!]], [[That's poopy, try again.]]))

  self.gobs:add(resultCard:addButton(self.uiContext:add(
    Button('Repeat Level', 0, 0, self.onRepeatLevel, self)
  )))

  self.gobs:add(resultCard:addButton(self.uiContext:add(
    Button('Quit', 0, 0, self.onQuit, self)
  )))
end

function YouLost:onRepeatLevel()
  self.parent:switch('ingame', levels[config.currentLevel])
end

function YouLost:onQuit()
  self.parent:switch('titleScreen')
end

function YouLost:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)
  local ingame = self.parent:get('ingame')
  ingame.gobs:update(dt)

  input:update(dt)

  if input:isPressed('trigger') then
    self.uiContext:triggerFocusedControl()
  end
end

function YouLost:mousemoved(x, y)
  local wx, wy = self.camera:worldCoords(x, y)
  self.uiContext:mousemoved(wx, wy)
end

function YouLost:draw()
  self.camera:startDraw()
  local ingame = self.parent:get('ingame')
  ingame.gobs:draw()
  self.gobs:draw()
  self.camera:endDraw()
end


function YouLost:__tostring()
  return 'YouLost'
end

return YouLost

