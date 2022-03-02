local config = {

  debugLevelIndex = 3,

  gravity = 40,

  ground = {
    height = 20,
  },

  building = {
    damageDistanceThreshold = 2, -- If my x is >= my downstairs x by this much, deal damage.
    damageThreshold = 5, -- How much damage a floor can take before being destroyed.
    downstairsDamageFactor = .9, -- When dealing damage to a downstairs, how much is damage amount multiplied by.
    downstairsFallDamageFactor = .1, -- Multiply the pixel distance fallen by this and deal as downstairs damage when one floor falls and hits another.
    fallDamageFactor = .3, -- Multiple the pixel distance fallen by this and deal damage to a floor when it finally stops falling.
    firstFloorDamageFactor = .34, -- During a quake, how much damage to do to the first floor. (i.e. it can't exceed the damageDistanceThreshold so would normally take no damage)
    jumpTime = .2, -- How long the floors jump when triggering the quake cursor in seconds.
    pieceDuration = 1.5, -- How long floor pieces last before being removed in seconds.
    settleTime = .6, -- How long the floors take to settle after triggering the quake cursor in seconds.
    shockDamage = 2, -- How much damage a floor can take from the initial quake cursor shock. Inversely proportional to its height from the ground.
    shockPowerThreshold = .95, -- Power from quake cursor must exceed this amount to cause a shock.
  },

  quake = {
    durationSeconds = 8,
  },

  -- 16x9
  graphics = {
    width = 320,
    height = 180,
    gameScale = 2,
    maxGameScale = 6,
    uiScaleFactor = 1/2,
  },

  sound = true,

}

return config
