local TestEnemyBullet = Object:extend()

-- circle attack pattern

function TestEnemyBullet:new(x, y, angle)
    self.pos = {x = x or 0, y = y or 0}
    self.vel = {x = 0, y = 0}
    self.angle = angle or 0
    self.speed = 100
    self.radius = 5
    self.time = 0
    self.maxTime = 1
    self.bulletSpawnTime = 0.025
    self.bulletSpawnCooldown = 0
    self.bullets = {}
    self.spawned = false
    return self
end

function TestEnemyBullet:update(dt)
    if self.bulletSpawnCooldown >= self.bulletSpawnTime and #self.bullets < 8 and not self.spawned then
        local angle = 0
        local i = #self.bullets + 1
        angle = math.rad(i * 360 / 8)
        local x = self.pos.x + math.cos(angle) * self.radius
        local y = self.pos.y + math.sin(angle) * self.radius
        table.insert(self.bullets, {pos = {x = x, y = y}, vel = {x = math.cos(angle) * 500, y = math.sin(angle) * 500}, time = 0, maxTime = 1, radius = 5})
        self.bulletSpawnCooldown = 0
        if #self.bullets == 8 then
            self.spawned = true
        end
    elseif self.spawned then
        for i, bullet in ipairs(self.bullets) do
            bullet.time = bullet.time + 1 * dt
            bullet.pos.x = bullet.pos.x + bullet.vel.x * dt
            bullet.pos.y = bullet.pos.y + bullet.vel.y * dt
            if bullet.time >= bullet.maxTime then
                table.remove(self.bullets, i)
            end

            if bullet.pos.x < 0 or bullet.pos.x > Inits.GameWidth or bullet.pos.y < 0 or bullet.pos.y > Inits.GameHeight then
                table.remove(self.bullets, i)
            end
        end
    else
        self.bulletSpawnCooldown = self.bulletSpawnCooldown + 1 * dt
    end
end

function TestEnemyBullet:draw()
    love.graphics.setColor(1, 0, 0, 1)
    for i, bullet in ipairs(self.bullets) do
        love.graphics.circle("fill", bullet.pos.x, bullet.pos.y, bullet.radius)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return TestEnemyBullet