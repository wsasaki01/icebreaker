function start_game()
    hub=false
    play=true

    dset(0, menu_op.h_type)
    dset(1, menu_op.mod)

    reset_tbls()
    p = create_player(menu_op.h_type, menu_op.mod)
    h = create_weapon(menu_op.h_type, menu_op.mod)
    local mem=get_mem_loc()
    dset(mem+5, 1)
    cont = create_controller(get_lvl(menu_c.pack,menu_c.lvl))

    l1_1=check_current_lvl(1,1)
    l1_2=check_current_lvl(1,2)
    l1_3=check_current_lvl(1,3)
    f1,f2,f3=true,false,false
end

function check_current_lvl(pack,lvl)
    return menu_c.pack==pack and menu_c.lvl==lvl
end

function format_score(s1, s2)
    local out = ""
    local scores = {s2, s1}
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
    for i=1, 8 do
        if tonum(current[i]) < tonum(record[i]) then
            return false
        elseif tonum(current[i]) > tonum(record[i]) then
            return true
        end
    end
    return false
end

function update_high_score()
    local score = format_score(p.score1, p.score2)
    local h_score = get_lvl_info()[4]
    if check_high_score(score,h_score) then
        dset(p.mem, p.score1)
        dset(p.mem+1, p.score2)
        gen_lvl_info()
    end
end

function update_high_combo(combo)
    if combo > get_lvl_info()[5] then
        dset(p.mem+4, round(combo))
        gen_lvl_info()
    end
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

function sum(tbl)
    local total=0
    for i in all(tbl) do
        total+=i
    end
    return total
end

function create_mob_tbl(tbl)
    local output={}

    for i=1, #tbl do
        if tbl[i]!=0 then
            for k=1, tbl[i] do
                add(output, i)
            end
        end
    end

    return output
end

function create_controller(level)
    return setmetatable({
        level=level,
        display_wave=1,
        wave=1, max_wave=#level,
        e_cnt=level[1][1],
        mobs=create_mob_tbl(level[1][2]),
        killed_mob_cnt=0,
        mob_total=sum(level[1][2]),

        display=false,
        display_line_cnt=2,
        display_fr=(25*2)+10,
        display_styles_cnt={-1, -1, -1, -1, -1},
        display_styles={█, ▒, ░, …},
        draw_cnt=-1,

        start_wait=false,
        main_wait=false,
        hit=false,

        totem_cnt=-1,
        path={14,16,16,16,16,16,15,6},

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

            local flag=false
            if not hit and h.attacking and draw_cnt==display_fr then
                for loc in all(h.attack_gap_list) do
                    if collide(
                        loc.x, loc.y, h.xw, h.yw,
                        70, 62, 8*#tostr(display_wave), 8*#tostr(display_wave)
                    ) then
                        flag = true
                    end
                end

                if collide(
                    h.x, h.y, h.xw, h.yw,
                    70, 62, 8*#tostr(display_wave), 8*#tostr(display_wave)
                ) then
                    flag = true
                end
            end

            if flag then
                sfx(0)
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
                    create_particle(74, 66, flr(rnd(2))==0 and 12 or 13, rnd(10)+4)
                end

                create_crack(77, 67, 6, 200)
                create_crack(77, 67, 13, 240)

                killed_mob_cnt=0
                display_styles_cnt={-1, -1, -1, -1, -1}

                display_wave+=1
                if wave!=max_wave or endless then
                    if (wave!=max_wave) wave+=1
                    e_cnt=level[wave][1]
                    mobs=create_mob_tbl(level[wave][2])
                    mob_total=sum(level[wave][2])
                else
                    _g.finished=true
                    _g.play=false
                    update_high_score()
                    if (unlocked==(menu_c.pack-1)*3+(menu_c.lvl)) dset(2, unlocked+1)
                end
            end
        end,

        draw_totem=function(_ENV)
            if (totem_cnt<=-1 and draw_cnt<=-1) return

            if display then
                local line=1
                if draw_cnt>get_stat_fr(line) then
                    line+=1
                    local w_score=remove_zero(p:score(false))
                    rprint("WAVE SCORE: ", 124-#w_score*4, 15, 3)
                    rprint(w_score, 124, 15, 11)
                    rprint(w_score, 124, 14, 3)

                    draw_fade_in(_ENV, 76-4*#w_score, 13, 1)                    
                end

                if draw_cnt>get_stat_fr(line) then
                    line+=1
                    rprint("BEST COMBO: ", 124-#tostr(p.w_combo_rec)*4, 25, 3)
                    rprint(p.w_combo_rec, 124, 25, 11)
                    rprint(p.w_combo_rec, 124, 24, 3)

                    draw_fade_in(_ENV, 76-4*#tostr(p.w_combo_rec), 23, 2)
                end

                local y_pos=35
                if p.w_full_combo and draw_cnt>get_stat_fr(line) then
                    line+=1
                    rprint("full wave combo!!", 124, y_pos, 9)

                    draw_fade_in(_ENV, 56, y_pos, 3)
                    y_pos+=10
                end

                if p.w_no_hit and draw_cnt>get_stat_fr(line) then
                    line+=1
                    rprint("no damage!!", 124, y_pos, 9)

                    draw_fade_in(_ENV, 80, y_pos, 4)
                    y_pos+=10
                end

                if p.w_wipeout and draw_cnt>get_stat_fr(line) then
                    line+=1
                    rprint("wipeout!!", 124, y_pos, 9)
                    
                    draw_fade_in(_ENV, 88, y_pos, 5)
                    y_pos+=10
                end
            end

            if not hit and totem_cnt!=-1 then
                if (totem_cnt==1) sfx(13)
                for i=1,totem_cnt do
                    print("\^t\^w"..display_wave, 73, 63-i, 12)
                end
                print("\^t\^w"..display_wave, 73, 62-totem_cnt, 2)
            elseif hit then
                if (totem_cnt==1) sfx(14)
                if (totem_cnt==8) sfx(15)
                for i=1,path[totem_cnt] do
                    print("\^t\^w"..display_wave, 73, 63-i, 12)
                end
                print("\^t\^w"..display_wave, 73, 62-path[totem_cnt], 2)
            end
        end,

        draw_fade_in=function(_ENV, left_x, y_pos, id)
            if (display_styles_cnt[id]<4) then
                display_styles_cnt[id]+=1
                if (display_styles_cnt[id]==0) sfx(12)
                fillp(display_styles[display_styles_cnt[id]])
                rectfill(left_x, y_pos, 124, y_pos+6, 7)
                fillp()
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
                display_fr=25*display_line_cnt+10
            end
        end,

        spawn_enemies = function(_ENV)
            while #enemies < e_cnt and #mobs>0 do
                local type=random_select(mobs)
                create_enemy(type)
                del(mobs, type)
            end
        end
    }, {__index=_ENV})
end

function draw_tbl(tbl)
    local output=""
    for i in all(tbl) do
        output=output..tostr(i)..","
    end
    print(output, 20, 20, 0)
end

function get_stat_fr(line)
    return (line*(cont.display_fr-10)/cont.display_line_cnt)-30
end