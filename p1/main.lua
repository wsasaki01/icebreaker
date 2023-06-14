function _init()
    p = {
        s = 1, temp_s = 0,
        x = 50, xw = 8,
        y = 50, yw = 8,
        score = 0,
        health = 3,
        i = 0,

        cooldown = 1*30,
        charge = true,

        sprite = function(self)
            self.s = h.equipped and 4 or 1
        end,

        die = function(self)
            for e in all(enemies) do
                if self.i == 0 and collide(self.x, self.y, self.yw, self.xw, e.x, e.y, e.xw, e.yw) then
                    self.health -= 1
                    self.i = 1*30
                end
            end

            if self.health == 0 then
                stop()
            end
        end,

        invincibilty = function(self)
            if self.i != 0 then
                self.s = 5
                self.i-=1
            end
        end
    }

    h = {
        s = 3,
        x = 100, xw = 8,
        y = 100, yw = 8,
        equipped = false,
        thrown = false,
        d = 0,
        v = 0,
        path = {x=0, y=0},

        draw = function(self)
            if not self.equipped then
                spr(self.s, self.x, self.y)
            end
        end,

        check = function(self)
            if collide(p.x, p.y, p.xw, p.yw, self.x, self.y, self.xw, self.yw) then
                self.equipped = true
                p.s = 4
            end
        end,
    }

    p_attack_length = 0.3
    p_attack_size = 7

    h_attack_length = 0.3
    h_attack_size = 4

    attacks = {}
    enemies = {}
    enemy_mt = {}

    enemy_limit = 10

    sh_str = 0
    hitstop = false
    hs_count = 0
    hs_frames = 3
end

function _update()
    if hitstop then
        hs_count += 1
        if hs_count == hs_frames then
            hitstop = false
            hs_count = 0
        end
    else
        diff = {x=0,y=0}

        if btn(1) and p.x<120 then
            p.x+=1
            diff.x+=1
        end

        if btn(0) and p.x>0 then
            p.x-=1
            diff.x-=1
        end

        if btn(2) and p.y>0 then
            p.y-=1
            diff.y-=1
        end

        if btn(3) and p.y<120 then
            p.y+=1
            diff.y+=1
        end

        if h.equipped then
            h.x = p.x
            h.y = p.y
            h.d = atan2(diff.x, diff.y)
        end

        if p.charge == p.cooldown then
            p.charge = true
        end

        if p.charge != true then
            p.charge += 1
        end

        if btn(5) and h.equipped and p.charge==true and #attacks<1 then
            p.charge = 0
            create_attack("player", p_attack_length, p_attack_size)
        end

        h:check()

        if btn(4) and h.equipped and (diff.x!=0 or diff.y!=0) then
            h.thrown = true
            h.equipped = false
            h.v = 10
            h.path = diff
            create_attack("hammer", h_attack_length, h_attack_size)
        end

        if h.v < 1 then
            h.thrown = false
            h.v = 0
            h.path={x=0, y=0}
        end

        if h.thrown then
            local x = h.x+cos(h.d)*h.v
            local y = h.y+sin(h.d)*h.v

            if x>=128 then
                h.x = 127
            elseif x <= 0 then
                h.x = 1
            else
                h.x = x
            end

            if y>=128 then
                h.y = 127
            elseif y <= 0 then
                h.y = 1
            else
                h.y = y
            end

            h.v*=0.8
        end

        if #enemies < enemy_limit then
            create_enemy()
        end

        for e in all(enemies) do
            e:move()
            e:die()
        end
        
        p:sprite()
        p:die()
        p:invincibilty()

        for a in all(attacks) do
            if a.type == "player" then
                attack_follow(a, p.x, p.y)
            elseif a.type == "hammer" then
                attack_follow(a, h.x, h.y)
            end

            a:decay()
        end
    end
end

function _draw()
    cls(7)

    camera(0, 0)

    log({
        p.charge,
    })

    print("❎ TO ROLL", 20, 50, 6)
    print("W/ HAMMER: 🅾️ TO THROW\n           ❎ TO SWING")

    for i=1,p.health do
        spr(6, i*10+80, 3)
    end

    print(p.score, 90, 12, 14)

    shake(0, 0)

    for a in all(attacks) do
        a:draw()
    end

    spr(p.s, p.x, p.y)

    for e in all(enemies) do
        e:draw()
    end

    h:draw()
end

function create_enemy()
    add(enemies, {
        x = flr(rnd(128)), xw = 8,
        y = flr(rnd(128)), yw = 8,
        speed = rnd(1)*0.8,

        move = function(self)
            local a = atan2(p.x-self.x, p.y-self.y)
            self.x+=cos(a)*self.speed
            self.y+=sin(a)*self.speed
        end,

        draw = function(self)
            spr(2, self.x, self.y)
        end,

        die = function(self)
            for a in all(attacks) do
                if collide(self.x, self.y, self.yw, self.xw, a.x, a.y, a.xw, a.yw) then
                    p.score+=1
                    sh_str+=0.1
                    hitstop = true
                    del(enemies, self)
                end
            end
        end
    })
end

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

function log(args)
    for i in all(args) do
        print(i, 0)
    end
end