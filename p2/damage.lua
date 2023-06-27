function create_attack(type, sec, r)
    if type == "player" then
        add(attacks, setmetatable({
            x = p.x, xw = 2*r,
            y = p.y, yw = 2*r,
            r=r,
            cnt = flr(sec*30),
            type = 0,

            draw = function(_ENV)
                circfill(x+p.xw/2, y+p.yw/2, r, 9)
            end,

            decay = function(self)
                self.cnt-=1
                if self.cnt==0 then
                    del(attacks, self)
                end
            end
        }, {__index=_ENV}))
    end
end

function a_follow(a, fx, fy)
    a.x = fx
    a.y = fy
end