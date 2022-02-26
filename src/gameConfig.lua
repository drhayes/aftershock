local config = {

  gravity = 40,

  ground = {
    height = 20,
  },

  building = {
    damageDistanceThreshold = 2,
    damageThreshold = 5,
    floorHeight = 20,
    downstairsDamageFactor = 1.5,
    fallDamageFactor = .3,
    downstairsFallDamageFactor = .1,
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
