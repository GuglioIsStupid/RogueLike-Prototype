local TestEnemy = Object:extend()

function TestEnemy:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.vel = {x = 0, y = 0}
    self.size = {x = 25, y = 25}
    self.speed = 100
    self.health = 1
    self.maxHealth = 1
    self.bulletType = "TestEnemyBullet"
    self.rndBulletCooldown = 0
    self.maxRndBulletCooldown = 0.55
    self.bullets = {}
    self.doingType = false

    return self
end

function TestEnemy:convertPlayerPositionToAngle()
    local angle = math.atan2(Player.pos.y - self.pos.y, Player.pos.x - self.pos.x)
    return angle
end

function TestEnemy:update(dt)
    self.vel.x, self.vel.y = 0, 0
    if self.pos.x < Player.pos.x then
        self.vel.x = self.vel.x + self.speed
    end
    if self.pos.x > Player.pos.x then
        self.vel.x = self.vel.x - self.speed
    end
    if self.pos.y < Player.pos.y then
        self.vel.y = self.vel.y + self.speed
    end
    if self.pos.y > Player.pos.y then
        self.vel.y = self.vel.y - self.speed
    end

    if not self.doingAttack then
        self.pos.x = self.pos.x + self.vel.x * dt
        self.pos.y = self.pos.y + self.vel.y * dt
    end

    if self.rndBulletCooldown >= self.maxRndBulletCooldown then
        self.doingAttack = true
        Timer.after(0.025*8, function() self.doingAttack = false end)
        local x = self.pos.x + self.size.x / 2
        local y = self.pos.y + self.size.y / 2
        table.insert(self.bullets, _G.BulletTypes[self.bulletType](x, y, self:convertPlayerPositionToAngle()))
        self.rndBulletCooldown = 0
    else
        self.maxRndBulletCooldown = love.math.random(0.5, 1)
        self.rndBulletCooldown = self.rndBulletCooldown + 1 * dt
    end

    for i, bullet in ipairs(self.bullets) do
        bullet:update(dt)
        if bullet.pos.x < 0 or bullet.pos.x > Inits.GameWidth or bullet.pos.y < 0 or bullet.pos.y > Inits.GameHeight then
            table.remove(self.bullets, i)
        end
    end
end

function TestEnemy:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
    for i, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return TestEnemy