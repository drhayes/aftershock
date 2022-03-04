local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local UIContext = require 'ui.context'
local config = require 'gameConfig'
local levels = require 'levels'
local Logo = require 'sprites.logo'
local Button = require 'ui.button'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height

local TitleScreen = Scene:extend()

function TitleScreen:new(registry, eventBus)
  TitleScreen.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()
  self.uiContext = UIContext()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function TitleScreen:enter()
  TitleScreen.super.enter(self)

  self.gobs:clear()
  self.uiContext:clear()

  self.gobs:add(Logo(SCREEN_WIDTH/2, 20))

  local buttons = {}
  table.insert(buttons, self.gobs:add(self.uiContext:add(Button('New Game', 0, 0, self.onNewGame, self))))
  table.insert(buttons, self.gobs:add(self.uiContext:add(Button('Credits', 0, 30, self.onCredits, self))))
  table.insert(buttons, self.gobs:add(self.uiContext:add(Button('Quit', 0, 70, self.onQuit, self))))

  local buttonY = SCREEN_HEIGHT/2
  for i = 1, #buttons do
    local button = buttons[i]
    button.x = SCREEN_WIDTH/2 - button.width/2
    button.y = buttonY
    buttonY = buttonY + button.height + 2
  end
end

function TitleScreen:onQuit()
  love.event.quit()
end

function TitleScreen:onCredits()
  log.debug('credits')
end

function TitleScreen:onNewGame()
  config.currentLevel = 1
  if config.debug then
    config.currentLevel = config.debugLevelIndex
  end
  self.parent:switch('ingame', levels[config.currentLevel])
end

function TitleScreen:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)

  input:update(dt)

  if input:isPressed('trigger') then
    self.uiContext:triggerFocusedControl()
  end

end

function TitleScreen:mousemoved(x, y)
  local wx, wy = self.camera:worldCoords(x, y)
  self.uiContext:mousemoved(wx, wy)
end

function TitleScreen:draw()
  self.camera:startDraw()
  self.gobs:draw()
  self.camera:endDraw()
end


function TitleScreen:__tostring()
  return 'TitleScreen'
end

return TitleScreen


