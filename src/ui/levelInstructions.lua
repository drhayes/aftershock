local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'
local tween = require 'lib.tween'

local lg = love.graphics
local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height

local LevelInstructions = GameObject:extend()

function LevelInstructions:new(text)
  self.text = lg.newText(defaultFont, text)
  self.text:setf({
    {1, 1, 1, 1},
    text,
  }, SCREEN_WIDTH, 'center')
  self.width, self.height = self.text:getWidth(), self.text:getHeight()
  LevelInstructions.super.new(self, 0, -10)

  self.alpha = 1
  self.fadeTween = tween.new(4, self, { alpha = 0}, 'inExpo')
  self.yTween = tween.new(1, self, { y = 30 }, 'outBounce')
end

function LevelInstructions:fade()
  self.fadeTween = tween.new(.5, self, { alpha = 0 }, 'inQuad')
end

function LevelInstructions:update(dt)
  LevelInstructions.super.update(self, dt)

  -- Don't just set removeMe since I can be removed early.
  local complete = self.fadeTween:update(dt)
  if complete then
    self.removeMe = true
  end
  self.yTween:update(dt)
end

function LevelInstructions:draw()
  LevelInstructions.super.draw(self)

  local y = math.floor(self.y)
  lg.push()
  palette.white(self.alpha)
  lg.draw(self.text, self.x, y)
  lg.pop()
end

function LevelInstructions:__tostring()
  return 'LevelInstructions'
end

return LevelInstructions

