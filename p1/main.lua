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

    if #enemies < 1 then
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
    local choice = flr(rnd(2))
    local enemy = {
        --x = choice==1 and flr(rnd(128)) or -5,
        --y = choice==0 and flr(rnd(128)) or -5,

        x = 100,
        y = 100,

        move = function(self)
            local a = atan2(p.x-self.x, p.y-self.y)
            self.x+=cos(a)
            self.y+=sin(a)
        end,

        draw = function(self)
            spr(2, self.x, self.y)
        end
    }
    add(enemies, enemy)
end