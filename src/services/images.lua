local Object = require 'lib.classic'

local Images = Object:extend()

function Images:new()
  self.quads = {}
  self.sizes = {}
end

function Images:init(image, json)
  self.image = image
  self.imageWidth, self.imageHeight = image:getDimensions()
  for i = 1, #json.meta.slices do
    local slice = json.meta.slices[i]
    local bounds = slice.keys[1].bounds
    local x, y, w, h = bounds.x, bounds.y, bounds.w, bounds.h
    self.quads[slice.name] = love.graphics.newQuad(x, y, w, h, self.imageWidth, self.imageHeight)
    self.sizes[slice.name] = { w = w, h = h, }
  end
end

function Images:getQuad(frameName)
  local quad = self.quads[frameName]
  if not quad then
    log.error('invalid quad', frameName)
  end
  return quad
end

function Images:getSize(frameName)
  local size = self.sizes[frameName]
  if not size then
    log.error('invalid frame name', frameName)
    return 0, 0
  end
  return size.w, size.h
end

function Images:__tostring()
  return 'Images'
end

return Images()
