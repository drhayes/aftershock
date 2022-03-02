return {
  {
    title = 'Getting Started',
    instructions = [[Knock over the building with your earthquake and aftershock!
Line them up for more damage!]],
    winCondition = function(gobs)
    end,
    buildings = {
      {
        type = 1,
        xPos = 160,
        height = 8,
      }
    },
  },
  {
    title = 'Moar Destruction',
    instructions = [[Now see if you can knock over all of 'em!
Short buildings are harder to knock over.
You might have to focus your energies...]],
    winCondition = function(gobs)
    end,
    buildings = {
      {
        type = 1,
        xPos = 120,
        height = 8,
      },
      {
        type = 2,
        xPos = 140,
        height = 12,
      },
      {
        type = 1,
        xPos = 200,
        height = 4,
      },
    },
  },
  {
    title = 'No Killing Houses',
    instructions = [[Don't knock over houses!]],
    winCondition = function(gobs)
      local isWin = true
      for i = 1, #gobs.gobs do
        local gob = gobs.gobs[i]
        if gob.isBuilding then
          if gob.buildingType == 3 and gob:isKindaDestroyed() then
            return false
          end
          if gob.buildingType ~= 3 and not gob:isCompletelyDestroyed() then
            return false
          end
        end
      end
      return true
    end,
    buildings = {
      {
        type = 1,
        xPos = 100,
        height = 6,
      },
      {
        type = 2,
        xPos = 130,
        height = 10,
      },
      {
        type = 3,
        xPos = 240,
        height = 2,
      },
      {
        type = 3,
        xPos = 270,
        height = 2,
      },
      {
        type = 3,
        xPos = 300,
        height = 3,
      },
    },
  },
}
