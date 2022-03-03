local Object = require 'lib.classic'

local Context = Object:extend()


function Context:new()
  self.controls = {}
  self.focusedControl = nil
end

function Context:clear()
  self.controls = {}
  self.focusedControl = nil
end

function Context:add(control)
  table.insert(self.controls, control)
  return control
end

function Context:mousemoved(x, y)
  local focusedControl = nil
  for i = 1, #self.controls do
    local control = self.controls[i]
    local top = control.y
    local bottom = top + control.height
    local left = control.x
    local right = left + control.width
    if x >= left and x <= right and y >= top and y <= bottom then
      focusedControl = control
    end
  end

  if self.focusedControl and self.focusedControl ~= focusedControl then
    self.focusedControl:blur()
  end

  if focusedControl and self.focusedControl ~= focusedControl then
    focusedControl:focus()
  end

  self.focusedControl = focusedControl

end

function Context:triggerFocusedControl()
  if not self.focusedControl then return end

  self.focusedControl:trigger()
end

function Context:__tostring()
  return 'Context'
end

return Context
