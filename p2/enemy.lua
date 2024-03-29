function create_enemy()
    add(enemies, setmetatable({
        x = bounds[1].x+flr(rnd(bounds[2].x-bounds[1].x)), xw = 8,
        y = bounds[1].y+flr(rnd(bounds[2].y-bounds[1].y)), yw = 8,
        speed = e_s_min + rnd(e_s_max-e_s_min),
        drop = (flr(rnd(20))==0 and p.health != p.max_health) and true or false,
        s = 7,
        spawn_cnt = 30,

        move = function(_ENV)
            local a = atan2(p.x-x, p.y-y)
            x+=cos(a)*speed
            y+=sin(a)*speed
        end,

        draw = function(_ENV)
            spr(s, x, y)
            if (drop and spawn_cnt==0) spr(23, x, y)
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

                if (h.type!=2 and h.thrown) or (h.thrown and h.v < 1.5 and h.magnet_v > h_magnet_v_min) then
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
                    local score = flr(100*speed/(e_s_min+e_range)*p.multi)
                    p:increase_score(score)
                    p.kill_cnt+=1
                    p.multi+=0.1 
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
                del(enemies, self)
                sh_str1+=0.1
                sh_str2+=0.09
                if hs < 3 then
                    hs = 3
                end
                sfx(0)
            end
        end
    }, {__index=_ENV}))
end