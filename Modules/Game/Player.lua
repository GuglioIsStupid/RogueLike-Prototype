---@class Player
local Player = Object:extend()

function Player:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.vel = {x = 0, y = 0}
    self.speed = 175
    self.shootCooldown = 0
    self.maxShootCooldown = 0.1
    self.bulletType = "PlayerBulletDefault"
    self.bullets = {}
    self.health = 3
    self.maxHealth = 3 -- upgradable
    self.invincibilityMaxTime = 0.75
    self.invincibilityTime = 0
    self.invincibilityBlinkTime = 0.1
    self.invincible = false

    return self
end

function Player:convertMousePositionToAngle(mx, my)
    local angle = math.atan2(my - self.pos.y+25/2, mx - self.pos.x+25/2)
    return angle
end

function Player:bulletCheckScreenBounds(bullet)
    if bullet.pos.x < 0 or bullet.pos.x > Inits.GameWidth or bullet.pos.y < 0 or bullet.pos.y > Inits.GameHeight then
        return true
    end
    return false
end

function Player:bulletCheckCollision(bullet, enemy)
    if bullet.pos.x < enemy.pos.x + enemy.size.x and
        bullet.pos.x + 5 > enemy.pos.x and
        bullet.pos.y < enemy.pos.y + enemy.size.y and
        bullet.pos.y + 5 > enemy.pos.y then
        return true
    end
    return false
end

function Player:update(dt)
    self.vel.x, self.vel.y = 0, 0
    if Input:down("MoveLeft") then
        self.vel.x = self.vel.x - self.speed
    end
    if Input:down("MoveRight") then
        self.vel.x = self.vel.x + self.speed
    end
    if Input:down("MoveUp") then
        self.vel.y = self.vel.y - self.speed
    end
    if Input:down("MoveDown") then
        self.vel.y = self.vel.y + self.speed
    end

    if self.shootCooldown >= self.maxShootCooldown and Input:down("PlayerShoot") then
        local mx, my = toGameScreen(love.mouse.getPosition())
        local angle = self:convertMousePositionToAngle(mx, my)
        table.insert(self.bullets, BulletTypes[self.bulletType](self.pos.x+25/2, self.pos.y+25/2, angle))
        self.shootCooldown = 0
    elseif self.shootCooldown < self.maxShootCooldown then
        self.shootCooldown = self.shootCooldown + 1 * dt
    end

    self.pos.x = self.pos.x + self.vel.x * dt
    self.pos.y = self.pos.y + self.vel.y * dt

    for i, bullet in ipairs(self.bullets) do
        bullet:update(dt)
        if self:bulletCheckScreenBounds(bullet) then
            table.remove(self.bullets, i)
        end
    end
end

function Player:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 25, 25, 6, 6)

    for i, bullet in ipairs(self.bullets) do
        bullet:draw()
    end

    return self
end

return Player