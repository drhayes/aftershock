local squeak = require 'lib.squeak'
local GameObject = squeak.gameObject
local config = require 'gameConfig'
local tween = require 'lib.tween'
local Text = require 'components.text'
local DialogFill = require 'components.dialogFill'

local PADDING = 5
local SCREEN_WIDTH, SCREEN_HEIGHT = config.graphics.width, config.graphics.height

local ResultCard = GameObject:extend()

function ResultCard:new(title, bodyText)
  ResultCard.super.new(self, 20, -SCREEN_HEIGHT)

  self.width = SCREEN_WIDTH - self.x
  self.height = SCREEN_HEIGHT - self.y
  self.alpha = 1

  local contentWidth = self.width - PADDING*2

  self.fill = self:add(DialogFill())

  self.title = self:add(Text(
    titleFont, title,
    PADDING, PADDING,
    contentWidth, 'center'))

  self.bodyText = self:add(Text(
    defaultFont, bodyText,
    PADDING, self.title.y + self.title.height + PADDING*2,
    contentWidth, 'center'
    ))

  self.alpha = 1
  -- Now adjust height so we keep the card so it fits.
  self.height = 10 + PADDING*2 + self.title.height + PADDING + self.bodyText.height

  -- Put it just off-screen.
  self.y = -self.height
  self.yTween = tween.new(1, self, { y = 30 }, 'outBounce')

end

function ResultCard:fade()
  self.fadeTween = tween.new(.5, self, { alpha = 0 }, 'inQuad')
  self.yTween = tween.new(.5, self, { y = SCREEN_HEIGHT * 2}, 'inQuad')
  self.isFading = true
end

function ResultCard:update(dt)
  ResultCard.super.update(self, dt)

  self.fill.alpha = self.alpha
  self.title.alpha = self.alpha
  self.bodyText.alpha = self.alpha

  -- Don't just set removeMe since I can be removed early.
  self.yTween:update(dt)
  if self.fadeTween then
    self.removeMe = self.fadeTween:update(dt)
  end
end

function ResultCard:__tostring()
  return 'ResultCard'
end

return ResultCard


