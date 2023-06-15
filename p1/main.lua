function _init()
    menu = true
    play = false
    retry = false

    p = {}
    h = {}

    p_attack_length = 0.3
    p_attack_size = 7

    h_attack_length = 0.3
    h_attack_size = 4

    enemy_limit = 10

    sh_str = 0
    hitstop = false
    hs_count = 0
    hs_frames = 3
end

function start_game()
    p = {
        s = 1, temp_s = 0,
        x = 50, xw = 8,
        y = 50, yw = 8,
        score = 0,
        health = 3,
        i = 0,
        d = 0,
        hit = false,
        hit_count = 0,
        hit_frames = 4,

        cooldown = 1*30,
        charge = true,

        rolling = false,
        roll_count = 0,
        roll_frames = 10,

        sprite = function(self)
            self.s = h.equipped and 4 or 1
        end,

        die = function(self)
            for e in all(enemies) do
                if e.spawn == 0 and self.i == 0 and collide(self.x+1, self.y+1, self.yw-2, self.xw-2, e.x+1, e.y+1, e.xw-2, e.yw-2) then
                    self.health -= 1
                    self.i = 1*30
                    self.hit = true
                    self.hit_count = self.hit_frames
                end
            end

            if self.health == 0 then
                play = false
                retry = true
            end
        end,

        invincibilty = function(self)
            if self.i != 0 then
                self.s = 5
                self.i-=1
            end
        end,

        roll = function(self)
            self.x += cos(self.d)*3
            self.y += sin(self.d)*3
            self.roll_count += 1
            if self.roll_count == self.roll_frames then
                self.rolling = false
                self.roll_count = 0
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
                sfx(1)
            end
        end,
    }

    attacks = {}
    enemies = {}
end

function _update()
    if menu then
        if btnp(5) then
            menu = false
            play = true
            start_game()
        end
    elseif play then
        if hitstop then
            hs_count += 1
            if hs_count == hs_frames then
                hitstop = false
                hs_count = 0
            end
        else
            if p.rolling then
                p:roll()
            else
                diff = {x=0,y=0}
                increment = h.equipped and 0.85 or 1

                if btn(1) and p.x<120 then
                    p.x+=increment
                    diff.x+=1
                end

                if btn(0) and p.x>0 then
                    p.x-=increment
                    diff.x-=1
                end

                if btn(2) and p.y>0 then
                    p.y-=increment
                    diff.y-=1
                end

                if btn(3) and p.y<120 then
                    p.y+=increment
                    diff.y+=1
                end
            end

            if h.equipped then
                h.x = p.x
                h.y = p.y
            else
                h:check()
            end

            if p.charge == p.cooldown then
                p.charge = true
            end

            if p.charge != true then
                p.charge += 1
            end

            if btn(5) then
                if h.equipped and p.charge==true and #attacks<1 then
                    p.charge = 0
                    create_attack("player", p_attack_length, p_attack_size)
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) then
                    p.rolling = true
                    p.i = p.roll_frames
                    p.d = atan2(diff.x, diff.y)
                end
            end

            if btn(4) and h.equipped and (diff.x!=0 or diff.y!=0) then
                h.thrown = true
                h.equipped = false
                h.v = 10
                h.path = diff
                sfx(2)
                create_attack("hammer", h_attack_length, h_attack_size)
            end

            if h.v < 1 then
                h.thrown = false
                h.v = 0
            end

            if h.thrown then
                h.d = atan2(h.path.x, h.path.y)

                local x = h.x+cos(h.d)*h.v
                local y = h.y+sin(h.d)*h.v

                if x>=120 then
                    h.x = 120
                    h.path.x *= -1
                    h.v *= 0.6
                elseif x <= 0 then
                    h.x = 0
                    h.path.x *= -1
                    h.v *= 0.6
                else
                    h.x = x
                end

                if y>=120 then
                    h.y = 120
                    h.path.y *= -1
                    h.v *= 0.6
                elseif y <= 0 then
                    h.y = 0
                    h.path.y *= -1
                    h.v *= 0.6
                else
                    h.y = y
                end

                h.v*=0.8
            end

            if #enemies < enemy_limit then
                create_enemy()
            end

            for e in all(enemies) do
                if e.spawn != 0 then
                    e.spawn -= 1
                else
                    e.s = 2
                    e:move()
                    e:die()
                end
            end
            
            p:die()
            p:sprite()
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
    elseif retry then
        if btnp("5") then
            retry = false
            play = true
            start_game()
        end
    end
end

function _draw()
    if menu then
        cls(14)
        print("icebreaker demo", 20, 50, 7)
        print("❎ to start")
    elseif play then
        cls(7)
        camera(0, 0)
    
        log({
            p.charge
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

        if p.hit then
            p.hit_count -= 1
            if p.hit_count == 0 then
                p.hit = false
            end
            rect(0, 0, 127, 127, 8)
            rect(1, 1, 126, 126, 14)
        end
    elseif retry then
        rectfill(20, 30, 80, 45, 2)
        print("❎ to retry", 26, 36, 7)
    end
end

function create_enemy()
    add(enemies, {
        x = flr(rnd(128)), xw = 8,
        y = flr(rnd(128)), yw = 8,
        speed = rnd(1)*0.8,
        s = 7,
        spawn = 30,

        move = function(self)
            local a = atan2(p.x-self.x, p.y-self.y)
            self.x+=cos(a)*self.speed
            self.y+=sin(a)*self.speed
        end,

        draw = function(self)
            spr(self.s, self.x, self.y)
        end,

        die = function(self)
            for a in all(attacks) do
                if collide(self.x, self.y, self.yw, self.xw, a.x, a.y, a.xw, a.yw) then
                    p.score+=1
                    sh_str+=0.1
                    hitstop = true
                    sfx(0)
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