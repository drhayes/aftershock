local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local ResultCard = require 'ui.resultCard'

local YouLost = Scene:extend()

function YouLost:new(registry, eventBus)
  YouLost.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function YouLost:enter()
  YouLost.super.enter(self)

  self.gobs:clear()

  self.gobs:add(ResultCard([[You've lost!]], [[That's poopy, try again.]]))
end

function YouLost:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)

  input:update(dt)

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

