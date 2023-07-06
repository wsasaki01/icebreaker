function create_enemy(type)
    local speed=e_s_min+rnd(e_s_range)
    local col=12

    if type==1 or type==2 or type==3 then
        local s_bounds=e_s_bounds[type]
        speed=s_bounds[1]+rnd(s_bounds[2]-s_bounds[1])
        if (type==2) col=9
        if (type==3) col=8
    end
    add(enemies, setmetatable({
        type=type,
        x = bounds[1].x+flr(rnd(bounds[2].x-bounds[1].x-8)), xw = 8,
        y = bounds[1].y+flr(rnd(bounds[2].y-bounds[1].y-8)), yw = 8,
        speed=speed,
        drop = (flr(rnd(20))==0 and p.health != p.max_health) and true or false,
        col = col,
        spawn_cnt=0,
        spawn_fr=30,

        move = function(_ENV)
            local a = atan2(p.x-x, p.y-y)
            x+=cos(a)*speed
            y+=sin(a)*speed
        end,

        draw = function(_ENV)
            if spawn_cnt==spawn_fr then
                pal(1,col)
                spr(192, x, y)
                pal()
                if (drop) spr(82, x, y)
            else
                spr(208+spawn_cnt\3, x, y)
            end
        end,

        die = function(self)
            local flag = false

            do
                local _ENV = self

                for a in all(attacks) do
                    if collide(
                        x, y, yw, xw,
                        a.x, a.y, a.xw, a.yw
                    ) then
                        flag = true
                    end
                end

                if h.attacking then
                    for loc in all(h.attack_gap_list) do
                        if collide(
                            x, y, xw, yw,
                            loc.x, loc.y, h.xw, h.yw
                        ) then
                            flag = true
                        end
                    end

                    if collide(
                        x, y, xw, yw,
                        h.x, h.y, h.xw, h.yw
                    ) then
                        flag = true
                    end
                end

                if flag then
                    local score = flr(100*speed/(e_s_min+e_s_range)*p.multi)
                    --create_float_score(score)
                    p:increase_score(score, true)
                    p:increase_score(score, false)
                    p.kill_cnt+=1
                    cont.killed_mob_cnt+=1
                    p.multi+=0.1
                    p.w_combo+=1
                    p.multi=ceil(p.multi*10)/10
                    p.combo_cnt=p.combo_fr
                    
                    if h.thrown then
                        h.hit_cnt+=1
                        h.last_hit = {x=x, y=y}
                    end
                    if drop then
                        create_heart(x, y)
                    end
                end
            end

            if flag then
                sh_str1+=0.1
                sh_str2+=0.09
                sh_str3+=0.09
                if hs < 3 then
                    hs = 3
                end
                sfx(0)
                for i=1,flr(rnd(6))+1 do
                    if h.type==2 then
                        create_particle(self.x, self.y, self.col, h.magnet_v)
                    else
                        create_particle(self.x, self.y, self.col, h.v)
                    end
                end
                del(enemies, self)
            end
        end,

        spawn = function(_ENV)
            if spawn_cnt != spawn_fr then
                spawn_cnt += 1
            end
        end
    }, {__index=_ENV}))
end