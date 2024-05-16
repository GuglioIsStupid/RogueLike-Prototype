local PlayerBulletDefault = Object:extend()

function PlayerBulletDefault:new(x, y, angle)
    self.pos = {x = x or 0, y = y or 0}
    self.vel = {x = 0, y = 0}
    self.angle = angle or 0
    return self
end

function PlayerBulletDefault:update(dt)
    self.vel.x = math.cos(self.angle) * 500
    self.vel.y = math.sin(self.angle) * 500

    self.pos.x = self.pos.x + self.vel.x * dt
    self.pos.y = self.pos.y + self.vel.y * dt
end

function PlayerBulletDefault:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 5, 5)
end

return PlayerBulletDefault