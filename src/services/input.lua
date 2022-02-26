local Object = require 'lib.classic'
local baton = require 'lib.baton'

local Input = Object:extend()

function Input:new()
  self.baton = baton.new({
    controls = {
      trigger = {'key:space', 'mouse:1', 'mouse:2'},
    },
  })
end

function Input:update(dt)
  self.baton:update(dt)
end

function Input:isDown(control)
  return self.baton:down(control)
end

function Input:isPressed(control)
  return self.baton:pressed(control)
end

function Input:isReleased(control)
  return self.baton:released(control)
end

function Input:__tostring()
  return 'Input'
end

return Input()
