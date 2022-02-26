local config = require 'gameConfig'

function love.conf(t)
  t.window.title = 'Aftershock'
  t.window.icon = 'media/images/icon.png'
  t.window.width = config.graphics.width * config.graphics.gameScale
  t.window.height = config.graphics.height * config.graphics.gameScale
  t.window.minwidth = config.graphics.width
  t.window.minheight = config.graphics.height
  t.window.resizable = true
  t.window.vsync = 1

  t.identity = 'aftershock'
  t.version = '11.4'
  t.modules.physics = false
  t.modules.touch = false
  t.modules.video = false
end
