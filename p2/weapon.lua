function create_weapon()
    return {
        s = 3,
        x = 100, xw = 8,
        y = 100, yw = 8,
        equipped = false,
        thrown = false, hit_cnt = 0, last_hit={x=0, y=0},
        d = 0,
        v = 0,
        path = {x=0, y=0},

        draw = function(self)
            if not self.equipped then
                spr(self.s, self.x, self.y)
            end
        end,

        check = function(self)
            if collide(p.x, p.y, p.xw, p.yw, self.x, self.y, self.xw, self.yw) and
            self.v < 1 then
                self.equipped = true
                p.s = 4
                sfx(1)
            end
        end,
    }
end