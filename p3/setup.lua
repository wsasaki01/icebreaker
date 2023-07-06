function start_game()
    dset(4, menu_op.h_type)
    dset(5, menu_op.mod)

    p = create_player(menu_op.h_type, menu_op.mod)
    h = create_weapon(menu_op.h_type, menu_op.mod)
    cont = create_controller(get_lvl(1))

    particles={}
    float_scores={}

    attacks = {}
    enemies = {}
    hit_signs = {}
    hearts = {}

    sh_str1 = 0
    sh_str2 = 0
    sh_str3 = 0

    fr=0
end

function format_score(s1, s2, s3)
    local out = ""
    local scores = {s3, s2, s1}
    for score in all(scores) do
        for i=1, 4-#tostr(score) do
            out=out.."0"
        end
        out=out..tostr(score)
    end
    return out
end

function remove_zero(score)
    while score[1] == "0" do
        score = sub(score, 2)
    end
    if (score == "") score = "0"
    return score
end

function check_high_score(current, record)
    for i=1, 12 do
        if tonum(current[i]) < tonum(record[i]) then
            return false
        elseif tonum(current[i]) > tonum(record[i]) then
            return true
        end
    end
    return false
end

function rng(min, max)
    return min < p.kill_cnt and p.kill_cnt <= max
end

function round(num)
    if (num%1>=0.5) return ceil(num)
    if (num%1<0.5) return flr(num)
end

function random_select(ops)
    return ops[flr(rnd(#ops))+1]
end

function create_controller(level)
    return setmetatable({
        level=level,
        display_wave=1,
        wave=1, max_wave=#level,
        e_cnt=level[1][1],
        mobs=level[1][2],
        selection={},

        finished=false,
        start_wait=false,

        display=false,
        display_line_cnt=2,
        display_fr=70,
        draw_cnt=-1,

        main_wait=false,
        hit=false,

        totem_cnt=-1,
        path={7,8,8,8,8,8,8,3},

        check_totem=function(_ENV)
            if draw_cnt>-1 and draw_cnt!=display_fr then
                draw_cnt+=1
            end

            if (draw_cnt==display_fr and totem_cnt==-1) totem_cnt=0

            if totem_cnt>-1 then
                totem_cnt+=1
            end

            if not hit and totem_cnt>=4 then
                totem_cnt=4
            end

            if start_wait and h.equipped then
                main_wait=true
                start_wait=false
            end
            if (not main_wait) return

            if not hit and h.attacking and draw_cnt==display_fr and collide(
                h.x, h.y, h.xw, h.yw,
                70, 62, 8, 8
            ) then
                hit=true
                display=false
                draw_cnt=-1
                totem_cnt=1

                _g.sh_str1+=0.1
                _g.hs=3
                p.multi+=0.1
            end

            if hit and totem_cnt>#path then
                totem_cnt=-1
                hit=false
                main_wait=false
                p.w_score1=0
                p.w_score2=0
                p.w_score3=0
                p.w_full_combo=true
                p.w_no_hit=true
                p.w_wipeout=false
                p.w_combo=0
                p.w_combo_rec=0
                _g.hs=3
                _g.sh_str1+=0.1
                _g.sh_str2+=0.09
                _g.sh_str3+=0.09
                for i=1,flr(rnd(25))+15 do
                    create_particle(74, 66, flr(rnd(2))==0 and 12 or 13)
                end
                display_wave+=1
            end
        end,

        draw_totem=function(_ENV)
            if (totem_cnt<=-1 and draw_cnt<=-1) return

            if display then
                local line=1
                if draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    local w_score=remove_zero(p:score(false))
                    rprint("WAVE SCORE: ", 124-#w_score*4, 15, 3)
                    rprint(w_score, 124, 15, 11)
                    rprint(w_score, 124, 14, 3)
                end

                if draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("BEST COMBO: ", 124-#tostr(p.w_combo_rec)*4, 25, 3)
                    rprint(p.w_combo_rec, 124, 25, 11)
                    rprint(p.w_combo_rec, 124, 24, 3)
                end

                local y_pos=35
                if p.w_full_combo and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("full wave combo!!", 124, y_pos, 9)
                    y_pos+=10
                end

                if p.w_no_hit and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("no damage!!", 124, y_pos, 9)
                    y_pos+=10
                end

                if p.w_wipeout and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("wipeout!!", 124, y_pos, 9)
                    y_pos+=10
                end
            end

            if not hit and totem_cnt!=-1 then
                for i=1,totem_cnt do
                    print(display_wave, 73, 66-i, 12)
                end
                print(display_wave, 73, 65-totem_cnt, 2)
            elseif hit then
                for i=1,path[totem_cnt] do
                    print(display_wave, 73, 66-i, 12)
                end
                print(display_wave, 73, 65-path[totem_cnt], 2)
            end
        end,

        check_wave=function(_ENV)
            if (#enemies>0) return

            local flag=true
            for item in all(mobs) do
                if (item!=0) flag=false
            end

            if flag and not start_wait and not main_wait then
                start_wait=true
                display=true
                draw_cnt=0
                display_line_cnt=2
                if (p.w_full_combo) display_line_cnt+=1
                if (p.w_no_hit) display_line_cnt+=1
                if (p.w_wipeout) display_line_cnt+=1
                display_fr=30*display_line_cnt+10

                if wave!=max_wave then
                    wave+=1
                    e_cnt=level[wave][1]
                    mobs=level[wave][2]
                else
                    finished=true
                end
            end
        end,

        update_quota = function(_ENV)
            selection={}
            for i=1, #mobs do
                if ((not main_wait and not start_wait) and (finished or mobs[i]!=0)) add(selection, i)
            end
        end,

        spawn_enemies = function(_ENV)
            while #enemies < e_cnt and #selection>0 do
                local type=random_select(selection)
                create_enemy(type)
                if not finished then
                    mobs[type]-=1
                    if mobs[type]==0 then
                        del(selection, type)
                    end
                end
            end
        end
    }, {__index=_ENV})
end