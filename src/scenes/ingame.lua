local squeak = require 'lib.squeak'
local Scene = squeak.scene

local Ingame = Scene:extend()

function Ingame:new(registry, eventBus)
  Ingame.super.new(self, registry, eventBus)
end


function Ingame:__tostring()
  return 'Ingame'
end

return Ingame
