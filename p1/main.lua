function _init()
    menu = true
    play = false
    retry = false

    cartdata("someguy17-icebreaker-p1")
    high_score = dget(0)
    high_combo = dget(1)

    p = {}
    h = {}

    p_attack_length = 0.3
    p_attack_size = 7

    h_attack_length = 0.3
    h_attack_size = 4

    enemy_limit = 10
    enemy_speed_lower = 0.4
    enemy_speed_upper = 1
    enemy_range = enemy_speed_upper - enemy_speed_lower 

    sh_str1 = 0
    sh_str2 = 0
    hitstop = false
    hs_count = 0
    hs_frames = 3

    retry_hold = 0
    retry_frames = 30
end

function start_game()
    p = {
        s = 1, temp_s = 0,
        x = 50, xw = 8,
        y = 50, yw = 8,
        score = 0, multi = 1,
        combo_record = 0,
        health = 3,

        combo_count = 0,
        combo_frames = 60,

        flash = false,
        i = false,
        i_count = 0,
        i_frame = false,

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

        draw = function(self)
            if not self.i then
                spr(self.s, self.x, self.y)
            elseif self.flash then
                if not self.i_frame then
                    spr(self.s, self.x, self.y)
                    self.i_frame = true
                else
                    self.i_frame = false
                end
            else
                spr(self.temp_s, self.x, self.y)
            end
        end,

        die = function(self)
            for e in all(enemies) do
                if e.spawn == 0 and not self.i and collide(self.x+1, self.y+1, self.yw-2, self.xw-2, e.x+1, e.y+1, e.xw-2, e.yw-2) then
                    self.health -= 1

                    self.hit = true
                    self.hit_count = self.hit_frames

                    self.combo_count = 0

                    self.i = true
                    self.i_count = 30
                    self.flash = true
                    self.temp_s = 5
                end
            end

            if self.health == 0 then
                play = false
                retry = true
                if p.score > high_score then
                    high_score = p.score
                    dset(0, p.score)
                end
            end
        end,

        invincibilty = function(self)
            if self.i_count != 0 then
                self.i_count-=1
            else
                self.i = false
                self.flash = false
            end
        end,

        roll = function(self)
            self.x += cos(self.d)*3
            self.y += sin(self.d)*3
            if self.x < 0 then
                self.x = 0
            end

            if self.x > 120 then
                self.x = 120
            end
            if self.y < 0 then
                self.y = 0
            end

            if self.y > 120 then
                self.y = 120
            end
            self.roll_count += 1
            self.temp_s = 8
            if self.roll_count == self.roll_frames then
                self.rolling = false
                self.roll_count = 0
            end
        end,

        combo = function(self)
            if self.combo_count != 0 then
                self.combo_count-=1
            else
                if (self.multi-1)*10 > self.combo_record then
                    self.combo_record = (self.multi-1)*10
                end

                if self.combo_record > high_combo then
                    high_combo = self.combo_record
                    dset(1, self.combo_record)
                end
                self.multi=1
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

            if btn(5) and not p.rolling then
                if h.equipped and p.charge==true and #attacks<1 then
                    p.charge = 0
                    create_attack("player", p_attack_length, p_attack_size)
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) then
                    p.rolling = true
                    p.i = true
                    p.i_count = 9
                    p.d = atan2(diff.x, diff.y)
                end
            end

            if btn(4) and not p.rolling and h.equipped and (diff.x!=0 or diff.y!=0) then
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
                    if 0.8*enemy_range+enemy_speed_lower < e.speed and e.speed < 0.9*enemy_range+enemy_speed_lower then
                        e.s = 18
                    elseif 0.9*enemy_range+enemy_speed_lower < e.speed then
                        e.s = 19
                    else
                        e.s = 2
                    end
                    e:move()
                    e:die()
                end
            end
            
            p:die()
            p:sprite()
            p:invincibilty()
            p:combo()

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
    
        print("❎ TO ROLL", 20, 50, 6)
        print("W/ HAMMER: 🅾️ TO THROW\n           ❎ TO SWING")
    
        for i=1,p.health do
            spr(6, i*10-8, 3)
        end
    
        sh_str1 = shake(0, 0, sh_str1)
    
        for a in all(attacks) do
            a:draw()
        end
    
        p:draw()
    
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

        sh_str2 = shake(0, 0, sh_str2)

        score()
    elseif retry then
        rectfill(20, 30, 100, 80, 2)
        print("❎ to retry", 26, 36, 7)
        print("THIS GAME:", 14)
        print("score:      "..tostr(p.score))
        print("best combo: "..tostr(p.combo_record))
        print("ALL-TIME:", 12)
        print("high score: "..tostr(high_score))
        print("best combo: "..tostr(high_combo))
    end
end

function create_enemy()
    add(enemies, {
        x = flr(rnd(128)), xw = 8,
        y = flr(rnd(128)), yw = 8,
        speed = enemy_speed_lower + rnd(enemy_speed_upper-enemy_speed_lower),
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
                    p.score+=flr(100*self.speed/(enemy_speed_lower+enemy_range))
                    p.multi+=0.1
                    p.multi=ceil(p.multi*10)/10
                    p.combo_count=p.combo_frames
                    sh_str1+=0.1
                    sh_str2+=0.09
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

function score()
    local score = tostr(p.score)
    local pos = 32
    local count = 0
    for char in all(score) do
        count += 1
        local digit = tonum(char)
        spr(64+digit, pos+7*count, 3)
    end

    if p.multi != 1 then
        spr(75, 33, 15)
        local multi = tostr(p.multi)
        local pos = 32
        local count = 0
        for char in all(multi) do
            count += 1
            if char != "." then
                local digit = tonum(char)
                spr(64+digit, pos+7*count, 15)
            else
                spr(74, pos+7*count, 15)
                pos -= 4
            end
        end

        if multi % 1 == 0 then
            count+=1
            spr(74, pos+7*count, 15)
            pos-=4
            count+=1
            spr(64, pos+7*count, 15)
        end
    end

    if p.combo_count != 0 then
        rect(33, 24, 33+p.combo_count, 24, 8)
        rect(33, 25, 33+p.combo_count, 25, 14)
    end
end