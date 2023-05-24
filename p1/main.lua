function _init()
    p = {
        x = 50,
        y = 50
    }

    enemies = {}
    enemy_mt = {}
end

function _update()
    if btn(1) and p.x<120 then p.x+=1 end
    if btn(0) and p.x>0 then p.x-=1 end
    if btn(2) and p.y>0 then p.y-=1 end
    if btn(3) and p.y<120 then p.y+=1 end

    if #enemies < 12 then
        gen_enemy()
    end
end

function _draw()
    cls(7)

    spr(1, p.x, p.y)

    for e in all(enemies) do
        e:move()
    end
    for e in all(enemies) do
        e:draw()
    end
end

function gen_enemy()
    local enemy = {
        x = flr(rnd(128)),
        y = flr(rnd(128)),
        speed = rnd(1)*0.8,

        move = function(self)
            local a = atan2(p.x-self.x, p.y-self.y)
            self.x+=(cos(a)*self.speed)
            self.y+=(sin(a)*self.speed)
        end,

        draw = function(self)
            spr(2, self.x, self.y)
        end
    }
    add(enemies, enemy)
end