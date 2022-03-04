-- Make those globals.
-- luacheck: globals inspect log
inspect = require 'lib.inspect'
log = require 'lib.log'
require('lib.batteries'):export()
local lily = require 'lib.lily'

-- Then some locals.
local config = require 'gameConfig'
local squeak = require 'lib.squeak'

local EventEmitter = squeak.eventEmitter
local Registry = squeak.registry
local SceneManager = squeak.sceneManager

local Ingame = require 'scenes.ingame'
local PreloadGame = require 'scenes.preloadGame'
local YouWon = require 'scenes.youWon'
local YouLost = require 'scenes.youLost'
local TitleScreen = require 'scenes.titleScreen'

-- Get that main loop online. Thanks, Max!
local main_loop = require('lib.ferris.main_loop')
main_loop()

local sceneManager

local function registerScenes(sceneManager, registry, eventBus)
  sceneManager:add('ingame', Ingame(registry, eventBus))
  sceneManager:add('preloadGame', PreloadGame(registry, eventBus))
  sceneManager:add('youWon', YouWon(registry, eventBus))
  sceneManager:add('youLost', YouLost(registry, eventBus))
  sceneManager:add('titleScreen', TitleScreen(registry, eventBus))
end


function love.load(arg)
  log.level = 'warn' -- luacheck: ignore
  for _, v in ipairs(arg) do
    if v == 'debug' then
      config.debug = true
      log.level = 'debug' -- luacheck: ignore
    elseif v == 'trace' then
      config.debug = true
      love.level = 'trace'
    end
  end

  log.info('~~~~ Aftershock ~~~~')

  -- Figure out a sensible gameScale based on screen resolution.
  local _, _, flags = love.window.getMode()
  -- The window's flags contain the index of the monitor it's currently in.
  local width, height = love.window.getDesktopDimensions(flags.display)
  local wFactor, hFactor = width / config.graphics.width, height / config.graphics.height
  local gameScale = math.min(math.floor(math.min(wFactor, hFactor)), config.graphics.maxGameScale)
  config.graphics.gameScale = gameScale
  -- Resize the window.
  love.window.setMode(gameScale * config.graphics.width, gameScale * config.graphics.height)

  -- Monkey-patch built-in random.
  math.random = love.math.random -- luacheck: ignore
  -- pixel art ftw
  love.graphics.setDefaultFilter('nearest','nearest', 1)
  love.graphics.setLineStyle('rough')
  love.mouse.setRelativeMode(false)

  eventBus = EventEmitter()
  sceneManager = SceneManager()
  local registry = Registry()

  registerScenes(sceneManager, registry, eventBus)

  eventBus:emit('setGameScale', gameScale)

  sceneManager:switch('preloadGame')
end

function love.draw()
  sceneManager:draw()
end

function love.update(dt)
  sceneManager:update(dt)
end

function love.resize(w, h)
  sceneManager:resize(w, h)
end

function love.keypressed(key, scancode, isRepeat)
  if key == 'f9' then
    love.graphics.captureScreenshot(os.date('%Y-%m-%d-%Hh-%Mm-%Ss.png')) -- luacheck: ignore
  elseif key == 'f10' then
    love.system.openURL('file://'..love.filesystem.getSaveDirectory())
  end
  sceneManager:keypressed(key, scancode, isRepeat)
end

function love.keyreleased(key, scancode)
  sceneManager:keyreleased(key, scancode)
end

function love.gamepadpressed(joystick, button)
  sceneManager:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
  sceneManager:gamepadreleased(joystick, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
  sceneManager:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch)
  sceneManager:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
  sceneManager:mousereleased(x, y, button, istouch)
end

function love.quit()
  lily.quit()
  log.info('Quitting.')
end

