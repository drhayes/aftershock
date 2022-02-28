local Object = require 'lib.classic'
local ripple = require 'lib.ripple'

local Sounds = Object:extend()

function Sounds:new()
  self.all = {}
  self.sfx = ripple.newTag()
end

function Sounds:addSfx(name, sound)
  local newSound = ripple.newSound(sound)
  newSound:tag(self.sfx)
  self.all[name] = newSound
end

function Sounds:play(name, pitch)
  pitch = pitch or 1
  local source = self.all[name]
  if not source then
    log.error('invalid sound name', name)
    return
  end

  local instance = source:play()
  instance.pitch = pitch
  instance.volume = 0.2
end

function Sounds:__tostring()
  return 'Sounds'
end

return Sounds()

