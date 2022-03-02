local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local palette = require 'core.palette'
local tween = require 'lib.tween'

local lg = love.graphics
local PADDING = 5
local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height

local ResultCard = GameObject:extend()

function ResultCard:new(title, instructions)
  ResultCard.super.new(self, SCREEN_WIDTH/2, -SCREEN_HEIGHT * 2)

  self.width = SCREEN_WIDTH - 20
  self.height = SCREEN_HEIGHT - 30
  self.alpha = 1

  self.title = lg.newText(titleFont, title)
  local titleWidth = self.title:getWidth()
  self.titleX = SCREEN_WIDTH/2 - titleWidth/2

  self.instructions = lg.newText(defaultFont, instructions)
  self.instructionsYOffset = self.title:getHeight() + PADDING*2
  self.instructions:setf({
    {1, 1, 1, 1},
    instructions,
  }, self.width - 10, 'center')

  self.alpha = 1
  self.yTween = tween.new(.5, self, { y = SCREEN_HEIGHT/2 }, 'outQuad')

  -- Now adjust height so we keep the card so it fits.
  self.height = 10 + PADDING * 2 + self.instructionsYOffset + self.instructions:getHeight()
end

function ResultCard:fade()
  self.fadeTween = tween.new(.5, self, { alpha = 0 }, 'inQuad')
  self.yTween = tween.new(.5, self, { y = SCREEN_HEIGHT * 2}, 'inQuad')
  self.isFading = true
end

function ResultCard:update(dt)
  ResultCard.super.update(self, dt)

  -- Don't just set removeMe since I can be removed early.
  self.yTween:update(dt)
  if self.fadeTween then
    self.removeMe = self.fadeTween:update(dt)
  end
end

function ResultCard:draw()
  ResultCard.super.draw(self)

  local top = math.floor(self.y) - self.height/2
  local bottom = math.floor(self.y) + self.height/2
  local left = self.x - self.width/2
  local right = self.x + self.width/2

  lg.push()

  palette.steel(self.alpha)
  lg.rectangle('fill', left, top, self.width, self.height)

  palette.white(self.alpha)
  lg.setLineWidth(2)
  lg.rectangle('line', left, top, self.width, self.height)
  lg.setLineWidth(1)
  lg.rectangle('line', left+3, top+3, self.width-6, self.height-6)

  lg.draw(self.title, self.titleX, top + PADDING)
  lg.draw(self.instructions, left + PADDING, top + PADDING + self.instructionsYOffset)

  lg.pop()
end

function ResultCard:__tostring()
  return 'ResultCard'
end

return ResultCard


