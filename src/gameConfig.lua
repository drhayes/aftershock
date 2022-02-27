local config = {

  gravity = 40,

  ground = {
    height = 20,
  },

  building = {
    damageDistanceThreshold = 2,
    damageThreshold = 5,
    downstairsDamageFactor = 1.5,
    downstairsFallDamageFactor = .1,
    fallDamageFactor = .3,
    floorHeight = 12,
    jumpTime = .2,
    settleTime = .6,
    pieceDuration = 1.5,
    shockDamage = 2,
    shockPowerThreshold = .95,
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
