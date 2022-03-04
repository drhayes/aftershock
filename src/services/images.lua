local Object = require 'lib.classic'

local Images = Object:extend()

function Images:new()
  self.quads = {}
  self.frameNameToImage = {}
  self.sizes = {}
end

function Images:add(image, jsonOrName)
  local imageWidth, imageHeight = image:getDimensions()
  if jsonOrName.meta then
    for i = 1, #jsonOrName.meta.slices do
      local slice = jsonOrName.meta.slices[i]
      local bounds = slice.keys[1].bounds
      local x, y, w, h = bounds.x, bounds.y, bounds.w, bounds.h
      local quad = love.graphics.newQuad(x, y, w, h, imageWidth, imageHeight)
      self.quads[slice.name] = quad
      self.frameNameToImage[slice.name] = image
      self.sizes[slice.name] = { w = w, h = h, }
    end
  else
    local quad = love.graphics.newQuad(0, 0, imageWidth, imageHeight, imageWidth, imageHeight)
    self.quads[jsonOrName] = quad
    self.frameNameToImage[jsonOrName] = image
    self.sizes[jsonOrName] = { w = imageWidth, h = imageHeight }
  end
end

function Images:getImage(frameName)
  local image = self.frameNameToImage[frameName]
  if not image then
    log.error('invalid frame name', frameName)
  end
  return image
end

function Images:getQuad(frameName)
  local quad = self.quads[frameName]
  if not quad then
    log.error('invalid frame name', frameName)
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
