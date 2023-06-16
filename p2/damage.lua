function create_attack(type, sec, r)
    add(attacks, {
        x = p.x, xw = 2*r,
        y = p.y, yw = 2*r,
        timer = flr(sec*30),
        type = type,

        draw = function(self)
            circfill(self.x+p.xw/2, self.y+p.yw/2, r, 9)
        end,

        decay = function(self)
            self.timer-=1
            if self.timer==0 then
                del(attacks, self)
            end
        end
    })
end

function attack_follow(a, fx, fy)
    a.x = fx
    a.y = fy
end