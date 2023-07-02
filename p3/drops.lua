function create_heart(x, y)
    add(hearts, {
        x = x, xw = 5,
        y = y, yw = 5,

        draw = function(self)
            spr(81, self.x, self.y)
        end,

        check = function(self)
            if collide(p.x, p.y, p.xw, p.yw, self.x, self.y, self.xw, self.yw) then
                if p.health != p.max_health then
                    p.health += 1
                    sfx(5)
                end
                del(hearts, self)
            end
        end
    })
end