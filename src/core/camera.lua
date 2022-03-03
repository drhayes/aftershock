local Object = require 'lib.classic'
local config = require 'gameConfig'
local Shaker = require 'core.shaker'

local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height
local lg = love.graphics

local Camera = Object:extend()

function Camera:new()
  self.canvas = lg.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
  self.gameScale = 1
  self.shaker = Shaker(50, math.pi/12, 1)
end

function Camera:update(dt)
  self.shaker:update(dt)
end

function Camera:addShake(chaos, threshold)
  self.shaker:add(chaos, threshold)
end

function Camera:startDraw()
  -- Draw to tiny canvas.
  lg.setCanvas(self.canvas)
  lg.setScissor(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  lg.push()
  lg.clear()
end

function Camera:endDraw()
  lg.pop()
  lg.setScissor()
  lg.setCanvas()

  -- Now draw to scaled canvas.
  lg.push()
  lg.setColor(1, 1, 1, 1)
  local x, y, r = self.shaker:get(0, 0, 0)
  lg.draw(self.canvas, x, y, r, self.gameScale)
  lg.pop()
end

function Camera:setGameScale(gameScale)
  self.gameScale = gameScale
end

function Camera:__tostring()
  return 'Camera'
end

return Camera
