local Player = Object:extend()

function Player:new(x, y)
    self.pos = {x = x or 0, y = y or 0}
    self.vel = {x = 0, y = 0}
    self.speed = 175
    self.shootCooldown = 0
    self.maxShootCooldown = 0.1
    self.bulletType = 'PlayerBulletDefault'
    self.bullets = {}

    return self
end

function Player:convertMousePositionToAngle(mx, my)
    local angle = math.atan2(my - self.pos.y+25/2, mx - self.pos.x+25/2)
    return angle
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