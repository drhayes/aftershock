local squeak = require 'lib.squeak'
local Scene = squeak.scene
local images = require 'services.images'
local json = require 'lib.json'
local lily = require 'lib.lily'
local input = require 'services.input'
local spriteMaker = require 'services.spriteMaker'

local lg = love.graphics

local Preload = Scene:extend()

function Preload:new(registry, eventBus)
  Preload.super.new(self, registry, eventBus)

  eventBus:on('setGameScale', self.onSetGameScale, self)
end

function Preload:enter()
  Preload.super.enter(self)

  self.loaders = {}

  table.insert(self.loaders, lily.newFont('media/fonts/m3x6.ttf', 16))
  table.insert(self.loaders, lily.newImage('media/images/buildings.png'))
  table.insert(self.loaders, lily.read('string', 'media/json/buildings.json', 'r'))
  table.insert(self.loaders, lily.newImageData('media/images/damageFont.png'))
  table.insert(self.loaders, lily.newImage('media/images/smallExplosion.png'))
  table.insert(self.loaders, lily.read('string', 'media/json/smallExplosion.json', 'r'))
end

function Preload:leave()
  Preload.super.leave(self)

  -- Font.
  local font = self.loaders[1]:getValues()
  lg.setFont(font)

  -- Buildings image and json.
  local buildingsImage = self.loaders[2]:getValues()
  local buildingsJsonString = self.loaders[3]:getValues()
  local buildingsJson = json.parse(buildingsJsonString)
  images:init(buildingsImage, buildingsJson)

  -- Damage font.
  damageFont = lg.newImageFont(self.loaders[4]:getValues(), '1234567890')

  -- Buildings image and json.
  local smallExplosionImage = self.loaders[5]:getValues()
  local smallExplosionJsonString = self.loaders[6]:getValues()
  local smallExplosionJson = json.parse(smallExplosionJsonString)
  spriteMaker:add('smallExplosion', smallExplosionImage, smallExplosionJson, 'boom')

  input:update(1)

  -- From this point forward, no more globals.
  setmetatable(_G, {
    __index = function(_, var) error('Unknown variable '..var, 2) end,
    __newindex = function(_, var) error('New variable not allowed '..var, 2) end,
    __metatable = function(_) error('Global variable protection', 2) end,
  })
end

function Preload:update(dt)
  Preload.super.update(self, dt)

  local isComplete = true
  for i = 1, #self.loaders do
    local loader = self.loaders[i]
    isComplete = isComplete and loader:isComplete()
  end

  if isComplete then
    self.parent:switch('ingame')
  end
end


-- function Preload:draw()
--   Preload.super.draw(self)

--   lg.push()
--   lg.clear()
--   lg.setColor(1, 1, 1, 1)
--   lg.print('Loading...')
--   lg.pop()
-- end

function Preload:onSetGameScale(gameScale)
  self.gameScale = gameScale
end

function Preload:__tostring()
  return 'Preload'
end

return Preload

