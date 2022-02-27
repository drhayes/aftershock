local squeak = require 'lib.squeak'
local Component = squeak.component
local spriteMaker = require 'services.spriteMaker'

local lg = love.graphics

local Animation = Component:extend()

function Animation:new(spriteName, x, y, r)
  Animation.super.new(self)

  self.sprite = spriteMaker:get(spriteName)
  self.sprite:play()
  self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight()
  self.sprite:onLoop(self.onLoop, self)
  self.x = x or 0
  self.y = y or 0
  self.r = r or 0
end

function Animation:onLoop()
  if self.onLoopCallback then
    self.onLoopCallback(self.onLoopCallbackArg)
  end
end

function Animation:setLoopCallback(callback, arg)
  self.onLoopCallback = callback
  self.onLoopCallbackArg = arg
end

function Animation:update(dt)
  self.sprite:update(dt)
end

function Animation:draw()
  local parent = self.parent

  local x = self.x + parent.x - self.w/2
  local y = self.y + parent.y - self.h/2

  lg.push()
  lg.setColor(1, 1, 1)
  self.sprite:draw(x, y, self.r)
  lg.pop()
end

function Animation:__tostring()
  return 'Animation'
end

return Animation
