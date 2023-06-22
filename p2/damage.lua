function create_attack(type, sec, r)
    if type == "player" then
        add(attacks, {
            x = p.x, xw = 2*r,
            y = p.y, yw = 2*r,
            cnt = flr(sec*30),
            type = 0,

            draw = function(self)
                circfill(self.x+p.xw/2, self.y+p.yw/2, r, 9)
            end,

            decay = function(self)
                self.cnt-=1
                if self.cnt==0 then
                    del(attacks, self)
                end
            end
        })
    end
end

function a_follow(a, fx, fy)
    a.x = fx
    a.y = fy
end