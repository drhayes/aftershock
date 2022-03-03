local squeak = require 'lib.squeak'
local Scene = squeak.scene
local GobsList = squeak.gobsList
local input = require 'services.input'
local Camera = require 'core.camera'
local ResultCard = require 'ui.resultCard'

local YouWon = Scene:extend()

function YouWon:new(registry, eventBus)
  YouWon.super.new(self, registry, eventBus)

  self.camera = Camera()
  self.gobs = GobsList()

  eventBus:on('setGameScale', self.camera.setGameScale, self.camera)
end

function YouWon:enter()
  YouWon.super.enter(self)

  self.gobs:clear()

  self.gobs:add(ResultCard([[You've won!]], 'Congratulations!!!'))
end

function YouWon:update(dt)
  self.camera:update(dt)
  self.gobs:update(dt)

  input:update(dt)

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
