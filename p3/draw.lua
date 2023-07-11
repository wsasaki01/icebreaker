function _draw()
    if hub or config then
        cls(7)

        camera(tran_cnt, 0)
        map(16, 0, 0, 9)
    
        camera(0,0)
        line(0, 8, 127, 8, 6)
        line(0, 8, 32, 8, 1)
    
        line(32, 7, 32, 9, 1)
        line(95, 7, 95, 9, 1)
    
        line(95, 8, 127, 8, 1)

        print("icebreaker", 34, 2, 12)
        rprint("V3.2", 95, 2, 13)

        if hub then
            for k,button_type_list in pairs(buttons) do
                if k<3 then
                    for button in all(button_type_list) do
                        button:draw()
                    end
                end
            end

            starter:draw()
        end

        if config then
            for k,button_type_list in pairs(buttons) do
                if k>2 then
                    for button in all(button_type_list) do
                        button:draw()
                    end
                end
            end
        end

        p:draw()    
        h:draw()
    
        rectfill(0, 121, 127, 127, 6)
        print("❎"..h_types[menu_op.h_type].x_hint.." 🅾️"..h_types[menu_op.h_type].o_hint, 1, 122, 7)
    elseif play then
        draw_play()
    elseif retry then
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
        print("high score: "..tostr(remove_zero(h_score)))
        print("best combo: "..tostr(h_combo))
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
        print("high score: "..tostr(remove_zero(h_score)))
        print("best combo: "..tostr(h_combo))
    end

    if mouse then
        pset(stat(32), stat(33), 15)
        print(stat(32).."\n"..stat(33), stat(32), stat(33)+3)
    end 
end

function draw_play()
    cls(7)
    camera(0, 0)

    map(0, 0, 0, 9)

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
        if p.hit_count == 0 then
            p.hit = false
        end
        rect(0, 0, 127, 127, 8)
        rect(1, 1, 126, 126, 14)
    end

    sh_str2 = shake(0, 0, sh_str2)

    score()

    sh_str3 = shake(0, 0, sh_str3)

    for i=1,p.health do
        spr(80, i*10-9, 1)
    end

    rectfill(0, 121, 127, 127, 6)
    print("❎"..h_types[menu_op.h_type].x_hint.." 🅾️"..h_types[menu_op.h_type].o_hint, 1, 122, 7)

    cursor(20, 70, 0)
    log({
        --"low: "..cont.mobs[1],
        --"med: "..cont.mobs[2],
        --"high: "..cont.mobs[3],
    })

    --[[
    for i in all(h.attack_gap_list) do
        rectfill(i.x, i.y, i.x+h.xw, i.y+h.yw, 0)
    end
    --]]
end