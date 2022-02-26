local squeak = require 'lib.squeak'
local Scene = squeak.scene
local images = require 'services.images'
local json = require 'lib.json'
local lily = require 'lib.lily'

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

end

function Preload:leave()
  -- Font.
  local font = self.loaders[1]:getValues()
  lg.setFont(font)

  -- Buildings image and json.
  local buildingsImage = self.loaders[2]:getValues()
  local buildingsJsonString = self.loaders[3]:getValues()
  local buildingsJson = json.parse(buildingsJsonString)
  images:init(buildingsImage, buildingsJson)
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


function Preload:draw()
  lg.push()
  lg.clear()
  lg.setColor(1, 1, 1, 1)
  lg.print('Loading...')
  lg.pop()
end

function Preload:onSetGameScale(gameScale)
  self.gameScale = gameScale
end

function Preload:__tostring()
  return 'Preload'
end

return Preload

