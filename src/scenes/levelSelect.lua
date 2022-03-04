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

local LevelSelect = Scene:extend()

function LevelSelect:new(registry, eventBus)
  LevelSelect.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()
  self.uiContext = UIContext()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function LevelSelect:enter()
  LevelSelect.super.enter(self)

  self.gobs:clear()
  self.uiContext:clear()

  self.gobs:add(Logo(SCREEN_WIDTH/2, 20))

  local function startLevel(levelIndex)
    self.parent:switch('ingame', levels[levelIndex])
  end

  local buttons = {}
  for i = 1, #levels do
    local level = levels[i]
    table.insert(buttons, self.gobs:add(self.uiContext:add(
      Button(level.title, 0, 0, startLevel, i)
    )))
  end

  local buttonY = SCREEN_HEIGHT/4
  for i = 1, #buttons do
    local button = buttons[i]
    button.x = SCREEN_WIDTH/2 - button.width/2
    button.y = buttonY
    buttonY = buttonY + button.height + 2
  end

  local backButton = self.gobs:add(self.uiContext:add(
    Button('Back to Title Screen', 0, buttonY + 20, self.onBackToTitle, self)
  ))
  backButton.x = SCREEN_WIDTH/2 - backButton.width/2
end

function LevelSelect:onBackToTitle()
  self.parent:switch('titleScreen')
end

function LevelSelect:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)

  input:update(dt)

  if input:isPressed('trigger') then
    self.uiContext:triggerFocusedControl()
  end

end

function LevelSelect:mousemoved(x, y)
  local wx, wy = self.camera:worldCoords(x, y)
  self.uiContext:mousemoved(wx, wy)
end

function LevelSelect:draw()
  self.camera:startDraw()
  self.gobs:draw()
  self.camera:endDraw()
end


function LevelSelect:__tostring()
  return 'LevelSelect'
end

return LevelSelect



