local TestState = State()

function TestState:enter()

end

function TestState:update(dt)
    Player:update(dt)
end

function TestState:draw()
    Player:draw()
end

return TestState