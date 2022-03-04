local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local UIContext = require 'ui.context'
local config = require 'gameConfig'
local levels = require 'levels'

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

end

function TitleScreen:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)

  input:update(dt)

  config.currentLevel = 1
  if config.debug then
    config.currentLevel = config.debugLevelIndex
  end
  self.parent:switch('ingame', levels[config.currentLevel])
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


