local Object = require 'lib.classic'

local Images = Object:extend()

function Images:new(image, json)
  self.image = image
  self.imageWidth, self.imageHeight = image:getDimensions()
  self.quads = {}
  for i = 1, #json.meta.slices do
    local slice = json.meta.slices[i]
    local bounds = slice.keys[1].bounds
    local x, y, w, h = bounds.x, bounds.y, bounds.w, bounds.h
    self.quads[slice.name] = love.graphics.newQuad(x, y, w, h, self.imageWidth, self.imageHeight)
  end
end

function Images:getBuildingQuad(buildingType, floorType, damageLevel)
  return self.quads[buildingType .. '-' .. floorType .. '-' .. damageLevel]
end

function Images:__tostring()
  return 'Images'
end

return Images
