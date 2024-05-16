local _gameScreen
Inits = require("Inits")
require("Modules.Utilities")

function toGameScreen(x, y)
    -- converts our mouse position to the game screen (canvas) with the correct ratio
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)

    local x, y = x - Inits.WindowWidth/2, y - Inits.WindowHeight/2
    x, y = x / ratio, y / ratio
    x, y = x + Inits.GameWidth/2, y + Inits.GameHeight/2

    return x, y
end

function love.load()
    Input = (require("Lib.baton")).new({
        controls = {
            MoveLeft = {"key:a", "key:left"},
            MoveDown = {"key:s", "key:down"},
            MoveUp = {"key:w", "key:up"},
            MoveRight = {"key:d", "key:right"},
            PlayerShoot = {"mouse:1", "key:j"}
        },
        joystick = love.joystick.getJoysticks()[1]
    })
    Timer = require("Lib.HUMP.timer")
    Object = require("Lib.class")
    State = require("Lib.state")

    States = {
        Testing = {
            TestState = require("Modules.States.TestState")
        }
    }

    BulletTypes = {
        PlayerBulletDefault = require("Modules.Game.Bullets.PlayerBulletDefault"),
        TestEnemyBullet = require("Modules.Game.Bullets.TestEnemyBullet")
    }
    Player = require("Modules.Game.Player"):new()
    TestEnemy = require("Modules.Game.Enemies.TestEnemy")

    State.switch(States.Testing.TestState)

    _gameScreen = love.graphics.newCanvas(Inits.GameWidth, Inits.GameHeight)
end

function love.update(dt)
    Input:update()
    Timer.update(dt)
    State.update(dt)
end

function love.resize(w, h)
    Inits.WindowWidth, Inits.WindowHeight = w, h
end

function love.draw()
    love.graphics.setCanvas({_gameScreen, stencil=true})
    love.graphics.clear(0,0,0,1)
    State.draw()
    love.graphics.setCanvas()

    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)

    love.graphics.setColor(1,1,1,1)
    -- draw game screen with the calculated ratio and center it on the screen
    love.graphics.draw(_gameScreen, Inits.WindowWidth/2, Inits.WindowHeight/2, 0, ratio, ratio, Inits.GameWidth/2, Inits.GameHeight/2)
end
