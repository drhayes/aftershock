local squeak = require 'lib.squeak'
local Scene = squeak.scene
local images = require 'services.images'
local json = require 'lib.json'
local lily = require 'lib.lily'
local input = require 'services.input'
local spriteMaker = require 'services.spriteMaker'
local sounds = require 'services.sounds'
local levels = require 'levels'
local config = require 'gameConfig'

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
  table.insert(self.loaders, lily.newSource('media/sfx/quakeCursor.wav', 'static'))
  table.insert(self.loaders, lily.newSource('media/sfx/smallExplosion.wav', 'static'))
  table.insert(self.loaders, lily.newImage('media/images/groundShock.png'))
  table.insert(self.loaders, lily.read('string', 'media/json/groundShock.json', 'r'))
  table.insert(self.loaders, lily.newSource('media/sfx/groundShock.wav', 'static'))
  table.insert(self.loaders, lily.newSource('media/sfx/sound_design_earthquake_rumble.mp3', 'static'))
  table.insert(self.loaders, lily.newFont('media/fonts/m5x7.ttf', 16))
  table.insert(self.loaders, lily.newImage('media/images/logo.png'))

end

function Preload:leave()
  Preload.super.leave(self)

  -- Font.
  local font = self.loaders[1]:getValues()
  defaultFont = font
  lg.setFont(font)
  titleFont = self.loaders[13]:getValues()

  -- Buildings image and json.
  local buildingsImage = self.loaders[2]:getValues()
  local buildingsJsonString = self.loaders[3]:getValues()
  local buildingsJson = json.parse(buildingsJsonString)
  images:add(buildingsImage, buildingsJson)

  local logoImage = self.loaders[14]:getValues()
  images:add(logoImage, 'logo')

  -- Damage font.
  damageFont = lg.newImageFont(self.loaders[4]:getValues(), '1234567890')

  -- Sprites.
  local smallExplosionImage = self.loaders[5]:getValues()
  local smallExplosionJsonString = self.loaders[6]:getValues()
  local smallExplosionJson = json.parse(smallExplosionJsonString)
  spriteMaker:add('smallExplosion', smallExplosionImage, smallExplosionJson, 'boom')

  local groundShockImage = self.loaders[9]:getValues()
  local groundShockJsonString = self.loaders[10]:getValues()
  local groundShockJson = json.parse(groundShockJsonString)
  spriteMaker:add('groundShock', groundShockImage, groundShockJson, 'zap')


  -- Sounds.
  sounds:addSfx('quakeCursor', self.loaders[7]:getValues())
  sounds:addSfx('smallExplosion', self.loaders[8]:getValues())
  sounds:addSfx('groundShock', self.loaders[11]:getValues())
  sounds:addSfx('quake', self.loaders[12]:getValues(), {
    volume = 0.5,
  })

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
    self.parent:switch('titleScreen')
  end
end


function Preload:onSetGameScale(gameScale)
  self.gameScale = gameScale
end

function Preload:__tostring()
  return 'Preload'
end

return Preload

