local TestState = State()

function TestState:enter()
    TEnemy = TestEnemy:new(0, 0)
end

function TestState:update(dt)
    Player:update(dt)
    TEnemy:update(dt)
end

function TestState:draw()
    Player:draw()
    TEnemy:draw()
end

return TestState