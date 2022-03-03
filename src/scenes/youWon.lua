local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local ResultCard = require 'ui.resultCard'
local Button = require 'ui.button'
local UIContext = require 'ui.context'

local YouWon = Scene:extend()

function YouWon:new(registry, eventBus)
  YouWon.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()
  self.uiContext = UIContext()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function YouWon:enter()
  YouWon.super.enter(self)

  self.gobs:clear()
  self.uiContext:clear()

  local resultCard = self.gobs:add(ResultCard([[You won!]], 'Congratulations!!!'))

  self.gobs:add(resultCard:addButton(self.uiContext:add(
    Button('Repeat Level', 0, 0, self.onRepeatLevel, self)
  )))

  self.gobs:add(resultCard:addButton(self.uiContext:add(
    Button('Next', 0, 0, self.onNextLevel, self)
  )))

end

function YouWon:onRepeatLevel()
  log.debug('repeat level')
end

function YouWon:onNextLevel()
  log.debug('next level')
end

function YouWon:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)
  local ingame = self.parent:get('ingame')
  ingame.gobs:update(dt)

  input:update(dt)

end

function YouWon:mousemoved(x, y)
  local wx, wy = self.camera:worldCoords(x, y)
  self.uiContext:mousemoved(wx, wy)
end

function YouWon:draw()
  self.camera:startDraw()
  local ingame = self.parent:get('ingame')
  ingame.gobs:draw()
  self.gobs:draw()
  self.camera:endDraw()
end


function YouWon:__tostring()
  return 'YouWon'
end

return YouWon
