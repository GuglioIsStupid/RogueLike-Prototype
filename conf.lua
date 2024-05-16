local Inits = require("Inits")

function love.conf(t)
    t.window.title = "Roguelike Prototype"
    t.identity = "untitled-roguelike-prototype"
    t.window.width = Inits.WindowWidth
    t.window.height = Inits.WindowHeight
end