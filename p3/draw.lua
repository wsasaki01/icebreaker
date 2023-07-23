function _draw()
    if hub or config or transition then
        cls(7)

        if (hub) camera(128*(-((tran_cnt/tran_fr -1)^2) +1), 0)
        if (config) camera(128*(tran_cnt/tran_fr)^2, 0)
        map(16, 0, 0, 9)
        pal(2,4)
        spr(128,114,61)
        print("▶",123,63,4)
        print("◀",130,63,4)
        pal()

        print("CURRENT:\n"..h_types[menu_op.h_type].name.."\n"..mods[menu_op.mod].name, 80, 14, 6)
        h.x,h.y=115,19
        h:draw()

        for k,button_type_list in pairs(buttons) do
            for button in all(button_type_list) do
                button:draw()
            end
        end

        print("off         on",7,104,3)
        if endless then
            sspr(104,40,16,16,20,96,16,16,true)
            sspr(88,40,16,16,36,96,16,16,true)
        else
            sspr(88,40,32,16,20,96)
        end
        print("endless",20,113,5)
    
        starter:draw()
        p:draw()

        camera(0,0)

        line(0, 8, 127, 8, 6)
        line(0, 8, 32, 8, 1)
    
        line(32, 7, 32, 9, 1)
        line(95, 7, 95, 9, 1)
    
        line(95, 8, 127, 8, 1)

        print("icebreaker", 34, 2, 12)
        rprint("V4.1", 95, 2, 13)

        rectfill(0, 121, 127, 127, 6)
        local txt
        if (hub or config) txt="❎ROLL" else txt="❎"..h_types[menu_op.h_type].x_hint.." 🅾️"..h_types[menu_op.h_type].o_hint
        print(txt, 1, 122, 7)
    elseif play then
        draw_play()
    elseif retry or finished then
        draw_play()
        rectfill(20, 30, 100, 88, 2)
        if (retry_cnt!=0) rectfill(25, 35, 25+32*(retry_cnt/retry_fr), 41, 13)
        if (return_cnt!=0) rectfill(25, 42, 25+68*(return_cnt/return_fr), 48, 13)
        print("❎ retry", 26, 36, 7)
        print("🅾️ return to menu", 26, 43)
        local info=get_lvl_info()
        print(
            "\feTHIS GAME:"..
            "\nscore:      "..remove_zero(p:score(true))..
            "\nbest combo: "..tostr(p.combo_rec)..
            "\n\fcALL-TIME:"..
            "\nhigh score: "..remove_zero(info[4])..
            "\nbest combo: "..info[5]
        )
    --[[
    elseif finished then
        draw_play()
        rectfill(20, 30, 100, 88, 2)
        if (retry_cnt!=0) rectfill(25, 35, 25+32*(retry_cnt/retry_fr), 41, 13)
        if (return_cnt!=0) rectfill(25, 42, 25+68*(return_cnt/return_fr), 48, 13)
        print("❎ retry", 26, 36, 7)
        print("🅾️ return to menu", 26, 43)
        print("THIS GAME:", 14)
        print("score:      "..remove_zero(p:score(true)))
        print("best combo: "..tostr(p.combo_rec))
        print("ALL-TIME:", 12)
        --print("high score: "..tostr(remove_zero(h_score)))
        --print("best combo: "..tostr(h_combo))
    --]]
    end

    --[[
    if mouse then
        pset(stat(32), stat(33), 0)
        print(stat(32).."\n"..stat(33), stat(32), stat(33)+3)
    end 
    --]]

    cursor(20, 70, 0)
    log({
    })
end

function draw_play()
    cls(7)
    camera(0, 0)

    map(0, 0, 0, 9)
    if (endless) spr(76, 117,112)

    local cols={7,7,7}
    local sint=105+4*sin(t())
    if l1_1 then
        if f1 then
            spr(79, 10, sint)
            circfill(103,103,8,6)
            print("PICK UP!", 88,112,3)
            if (h.equipped) f1=false f2=true
        end

        if f2 then
            spr(79, 30, sint)
            spr(79, 55, sint)
            if (h.thrown) f2=false
        end
    end

    if l1_2 and cont.wave==1 and not cont.hit and cont.draw_cnt==cont.display_fr then
        spr(79, 72, sint-60)
        print("THROW FOR\nNEXT WAVE!", 58, 75, 3)
    end

    if l1_3 and cont.wave==1 and not (cont.main_wait or cont.start_wait) then
        print("COMBO FOR\nHIGHER SCORE!", 35, 12, 3)
    end

    sh_str1 = shake(0, 0, sh_str1)

    line(0, 8, 127, 8, 6)
    line(0, 8, 32, 8, 1)

    line(32, 7, 32, 9, 1)
    line(95, 7, 95, 9, 1)

    line(95, 8, 127, 8, 1)

    for crack in all(cracks) do
        crack:draw()
    end

    pal(0, 7)
    print("\^#wave", 53, 65, 15)
    print("\^#\^t\^w"..cont.display_wave, 73, 62, 15)
    pal()

    for p in all(particles) do
        p:draw()
    end

    local w=flr(11*(cont.killed_mob_cnt/cont.mob_total))
    clip(0, 72-w, 128, 11)
    print("wave", 53, 65, 14)
    print("\^t\^w"..cont.display_wave, 73, 62, 14)
    clip()

    cont:draw_totem()

    for hs in all(hit_signs) do
        hs:draw()
    end

    for a in all(attacks) do
        a:draw()
    end

    p:draw()

    if p.tpdata[1] then
        circfill(p.tpdata[2], p.tpdata[3], 2, 0)
        fillp(▒)
        line(p.tpdata[2], p.tpdata[3], p.x+p.xw/2, p.y+p.yw/2, 0)
        fillp(█)
    end

    for e in all(enemies) do
        e:draw()
    end

    h:draw()

    for heart in all(hearts) do
        heart:draw()
    end

    if p.hit then
        p.hit_count -= 1
        p.hit = p.hit_count != 0
        rect(0, 0, 127, 127, 8)
        rect(1, 1, 126, 126, 14)
    end

    sh_str2 = shake(0, 0, sh_str2)

    if (not l1_1 and not l1_2) score()

    sh_str3 = shake(0, 0, sh_str3)

    for i=1,p.health do
        spr(80, i*10-9, 1)
    end

    rectfill(0, 121, 127, 127, 6)
    print("❎"..h_types[menu_op.h_type].x_hint.." 🅾️"..h_types[menu_op.h_type].o_hint, 1, 122, 7)
end