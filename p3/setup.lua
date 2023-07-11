function start_game()
    hub=false
    play=true

    dset(4, menu_op.h_type)
    dset(5, menu_op.mod)

    local pack,lvl=0,0
    for lvl_btn in all(buttons[2]) do
        if lvl_btn.pressed then
            pack=lvl_btn.parent_cnt
            lvl=lvl_btn.cnt
        end
    end

    reset_tbls()
    p = create_player(menu_op.h_type, menu_op.mod)
    cont = create_controller(get_lvl(pack,lvl))
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
                    create_particle(74, 66, flr(rnd(2))==0 and 12 or 13, rnd(10)+4)
                end

                create_crack(77, 67, 6, 200)
                create_crack(77, 67, 13, 240)

                killed_mob_cnt=0
                display_styles_cnt={-1, -1, -1, -1, -1}

                display_wave+=1
                if wave!=max_wave then
                    wave+=1
                    e_cnt=level[wave][1]
                    mobs=create_mob_tbl(level[wave][2])
                    mob_total=sum(level[wave][2])
                else
                    _g.finished=true
                    _g.play=false
                end
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
                    if (display_styles_cnt[1]<4) then
                        display_styles_cnt[1]+=1
                        if (display_styles_cnt[1]==0) sfx(12)
                        fillp(display_styles[display_styles_cnt[1]])
                        rectfill(76-4*#w_score, 13, 124, 20, 7)
                        fillp()
                    end
                end

                if draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("BEST COMBO: ", 124-#tostr(p.w_combo_rec)*4, 25, 3)
                    rprint(p.w_combo_rec, 124, 25, 11)
                    rprint(p.w_combo_rec, 124, 24, 3)

                    if (display_styles_cnt[2]<4) then
                        display_styles_cnt[2]+=1
                        if (display_styles_cnt[2]==0) sfx(12)
                        fillp(display_styles[display_styles_cnt[2]])
                        rectfill(76-4*#tostr(p.w_combo_rec), 23, 124, 30, 7)
                        fillp()
                    end
                end

                local y_pos=35
                if p.w_full_combo and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("full wave combo!!", 124, y_pos, 9)

                    if (display_styles_cnt[3]<4) then
                        display_styles_cnt[3]+=1
                        if (display_styles_cnt[3]==0) sfx(12)
                        fillp(display_styles[display_styles_cnt[3]])
                        rectfill(56, y_pos, 124, y_pos+6, 7)
                        fillp()
                    end

                    y_pos+=10
                end

                if p.w_no_hit and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("no damage!!", 124, y_pos, 9)

                    if (display_styles_cnt[4]<4) then
                        display_styles_cnt[4]+=1
                        if (display_styles_cnt[4]==0) sfx(12)
                        fillp(display_styles[display_styles_cnt[4]])
                        rectfill(80, y_pos, 124, y_pos+6, 7)
                        fillp()
                    end

                    y_pos+=10
                end

                if p.w_wipeout and draw_cnt>(line*(display_fr-10)/display_line_cnt)-30 then
                    line+=1
                    rprint("wipeout!!", 124, y_pos, 9)

                    if (display_styles_cnt[5]<4) then
                        display_styles_cnt[5]+=1
                        if (display_styles_cnt[5]==0) sfx(12)
                        fillp(display_styles[display_styles_cnt[5]])
                        rectfill(88, y_pos, 124, y_pos+6, 7)
                        fillp()
                    end

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