function create_player(type, mod)
    local move_multi=1
    local multiplier=1
    local a_len=0.3
    local a_size=7
    local combo_fr=60

    if type==2 then
        combo_fr*=2
    end

    if mod==2 then -- giant
        move_multi=0.5
        multiplier=1.5
        a_size=11
    elseif mod==3 then -- tiny
        move_multi=1.17
        multiplier=3.5
        combo_fr*=0.75
    --elseif mod==4 then -- reverse
    end

    return setmetatable({
        s = 1, temp_s = 0, -- sprite
        stand_anim={1,2,3,4},
        move_anim={17,18,19,20,21},
        hold_stand_anim={33,34,35,36},
        hold_move_anim={49,50,51,52},
        roll_anim={6,7,8,9,10},
        moving=false, left=false,

        guide=mod==5,
        x = 50, xw = 8,
        y = 50, yw = 8,
        d = 0,
        force = {v=0, dir=0},
        move_multi=move_multi,
        score1 = 0, score2 = 0, score3 = 0,
        multi=multiplier, base_multi=multiplier, combo_rec = 0,
        health = 3, max_health = 3,
        tpdata = {false},

        a_len = a_len,
        a_size = a_size,
        kill_cnt = 0,

        combo_cnt = 0,
        combo_fr = combo_fr,

        -- inv
        flash = false,
        i = false,
        i_cnt = 0,
        i_fr = false,

        -- damaged frame effect
        hit = false,
        hit_count = 0,
        hit_frames = 4,

        a_cooldown = 1*30,
        a_charge = true,

        rolling = false,
        roll_cnt = 0,
        roll_fr = 10,
        roll_cooldown = false,
        roll_fr_start = 0,

        move = function(_ENV)
            -- normal movement
            local diff = {x=0,y=0}
            local step = (h.equipped and 0.85*move_multi or 1)

            if btn(1) and x<bounds[2].x-xw then
                x+=step
                diff.x+=1
            end

            if btn(0) and x>bounds[1].x then
                x-=step
                diff.x-=1
            end

            if btn(3) and y<bounds[2].y-yw then
                y+=step
                diff.y+=1
            end

            if btn(2) and y>bounds[1].y then
                y-=step
                diff.y-=1
            end

            if force.v > 1 then
                local destx = x+cos(force.dir)*force.v
                local desty = y+sin(force.dir)*force.v

                if destx>=bounds[2].x-xw then
                    x = bounds[2].x-xw
                    force.v *= 0.6
                elseif destx<=bounds[1].x then
                    x = bounds[1].x
                    force.v *= 0.6
                else
                    x = destx
                end

                if desty>=bounds[2].y-yw then
                    y = bounds[2].y-yw
                    force.v *= 0.6
                elseif desty<=bounds[1].y then
                    y = bounds[1].y
                    force.v *= 0.6
                else
                    y = desty
                end

                force.v*=0.8
            else
                force.v = 0
            end

            moving=(diff.x!=0 or diff.y!=0)
            if (diff.x==-1) left=true
            if (diff.x==1) left=false
            return diff
        end,

        sprite = function(_ENV)
            if rolling then
                local frame=flr((fr-roll_fr_start)/2)+1
                if (frame<=5) s=roll_anim[frame]
                if (frame>5) s=roll_anim[5]
            elseif moving then
                if h.equipped then
                    s=hold_move_anim[flr(fr/4)%4+1]
                else
                    s=move_anim[flr(fr/3)%5+1]
                end
            else
                if h.equipped then
                    s=hold_stand_anim[flr(fr/10)%4+1]
                else
                    s=stand_anim[flr(fr/3)%4+1]
                end
            end
        end,

        draw = function(_ENV)
            if guide and moving and not h.equipped and not rolling then
                local x=p.x+p.xw/2+3.019*10*cos(d)
                local y=p.y+p.yw/2+3.019*10*sin(d)
                line(p.x+p.xw/2, p.y+p.yw/2, x, y, 13)
                circfill(x, y, 2, 13)
            end

            ovalfill(x, y+yw-1, x+xw, y+yw+1, 6)
            if flash then
                if not i_fr then
                    spr(s, x, y, 1,1, left)
                    i_fr = true
                else
                    i_fr = false
                end
            else
                spr(s, x, y, 1,1, left)
            end
        end,

        die = function(_ENV)
            for e in all(enemies) do
                if e.spawn_cnt == e.spawn_fr and not i and collide(x+1, y+1, yw-2, xw-2, e.x+1, e.y+1, e.xw-2, e.yw-2) then
                    health -= 1
                    sfx(4)

                    combo_cnt = 0

                    i = true
                    i_cnt = 40
                    flash = true
                    temp_s = 5

                    _g.sh_str3+=0.09
                    _g.hs = 10
                end
            end

            if health == 0 then
                if _g.hs == 0 then
                    _g.play = false
                    _g.retry = true
                    i=false
                    flash=false
                    local score = _g.format_score(score1, score2, score3)
                    if check_high_score(score, _g.h_score) then
                        _g.h_score = score
                        dset(0, score1)
                        dset(1, score2)
                        dset(2, score3)
                    end
                end
            end
        end,

        cooldown = function(_ENV)
            if (a_charge == true) or a_charge == a_cooldown then
                a_charge = true
            else
                a_charge += 1
            end
        end,

        inv = function(_ENV)
            if i_cnt != 0 then
                i_cnt-=1
            else
                i = false
                flash = false
            end
        end,

        roll = function(_ENV)
            if roll_cooldown == true then
                roll_cooldown = false
                rolling = false
            else
                x += cos(d)*10/(roll_cnt+1)
                y += sin(d)*10/(roll_cnt+1)
                if x < bounds[1].x then
                    x = bounds[1].x
                end

                if x > bounds[2].x-xw then
                    x = bounds[2].x-xw
                end
                if y < bounds[1].y then
                    y = bounds[1].y
                end

                if y > bounds[2].y-yw then
                    y = bounds[2].y-yw
                end
                roll_cnt += 1
                if roll_cnt == roll_fr then
                    roll_cnt = 0
                    roll_cooldown = true
                end
            end
        end,

        score = function(_ENV)
            return format_score(score1, score2, score3)
        end,

        combo = function(_ENV)
            if combo_cnt != 0 then
                if (not cont.waiting and not cont.start_wait) combo_cnt-=1
            else
                if (multi-1-base_multi)*10 > combo_rec then
                    combo_rec = round((multi-1-base_multi)*10)
                end

                if combo_rec > h_combo then
                    h_combo = round(combo_rec)
                    dset(3, round(combo_rec))
                end
                
                multi=base_multi
            end
        end,

        increase_score = function(_ENV, int)
            score1 += int
            if (score1>9999) then
                score2+=1
                score1-=9999
            end

            if (score2>9999) then
                score3+=1
                score2-=9999
            end
        end,

        tp = function(_ENV)
            tpdata={true, x+xw/2, y+yw/2}
            h.equipped=true
            x=h.x
            y=h.y
            _g.hs=3
            sfx(8)
        end
    }, {__index=_ENV})
end