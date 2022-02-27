local Object = require 'lib.classic'
local peachy = require 'lib.peachy'

local SpriteMaker = Object:extend()

function SpriteMaker:new()
  self.sprites = {}
  self.sizes = {}
end

function SpriteMaker:add(name, image, json, initial)
  self.sprites[name] = function()
    return peachy.new(json, image, initial)
  end
  local frame = json.frames[1]
end

function SpriteMaker:get(name)
  local sprite = self.sprites[name]
  if not sprite then
    log.error('invalid sprite name', name)
    return nil
  end
  return sprite()
end



function SpriteMaker:__tostring()
  return 'SpriteMaker'
end

return SpriteMaker()

