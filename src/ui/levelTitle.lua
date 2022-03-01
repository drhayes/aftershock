local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'
local tween = require 'lib.tween'

local lg = love.graphics
local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height

local LevelTitle = GameObject:extend()

function LevelTitle:new(text)
  self.text = lg.newText(titleFont, text)
  self.width, self.height = self.text:getWidth(), self.text:getHeight()
  LevelTitle.super.new(self, SCREEN_WIDTH/2 - self.width/2, -10)

  self.alpha = 1
  self.fadeTween = tween.new(4, self, { alpha = 0}, 'inExpo')
  self.yTween = tween.new(1, self, { y = 10 }, 'outBounce')
end

function LevelTitle:fade()
  self.fadeTween = tween.new(.5, self, { alpha = 0 }, 'inQuad')
end

function LevelTitle:update(dt)
  LevelTitle.super.update(self, dt)

  -- Don't just set removeMe since I can be removed early.
  local complete = self.fadeTween:update(dt)
  if complete then
    self.removeMe = true
  end
  self.yTween:update(dt)
end

function LevelTitle:draw()
  LevelTitle.super.draw(self)

  local y = math.floor(self.y)
  lg.push()
  palette.white(self.alpha)
  lg.draw(self.text, self.x, y)
  lg.setLineWidth(1)
  lg.line(self.x, y, self.x + self.width, y)
  lg.line(self.x, y + self.height + 2, self.x + self.width, y + self.height + 2)
  lg.pop()
end

function LevelTitle:__tostring()
  return 'LevelTitle'
end

return LevelTitle
