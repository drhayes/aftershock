local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local Image = require 'components.image'

local Logo = GameObject:extend()

function Logo:new(x, y)
  Logo.super.new(self, x, y)

  self:add(Image('logo'))
end


function Logo:__tostring()
  return 'Logo'
end

return Logo


