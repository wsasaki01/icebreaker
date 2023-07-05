function _draw()
    if menu then
        cls(1)
        print("\^i\^t\^wicebreaker demo", 5, 5, 12)
        print("\^w▶", 5, 20+18*(mc-1), 7)
        print("hAMMER:\t⬅️ "..h_types[menu_op.h_type].name.." ➡️", 15, 20, mc==1 and 7 or 12)
        print(menu_op.h_type.."/"..#h_types, 112, 20)
        print(h_types[menu_op.h_type].desc.."\n", 48, 26)
        print("mOD:\t\t⬅️ "..mods[menu_op.mod].name.." ➡️", 15, 38, mc==2 and 7 or 12)
        print(menu_op.mod.."/"..#mods, 112, 38)
        print(mods[menu_op.mod].desc, 48, 44)
        print(mods[menu_op.mod].perk, 11)
        print(mods[menu_op.mod].disad, 8)

        if (start_cnt != 0) rectfill(14, 79, 14+44*start_cnt/start_fr, 85, 7)
        print("\n❎ to start\n", 15, 74, 12)
        print("high score: "..tostr(remove_zero(h_score)), 6)
        print("best combo: "..tostr(h_combo))
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
        print("score:      "..remove_zero(format_score(p.score1, p.score2, p.score3)))
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

    print("wave "..cont.display_wave, 53, 65, 6)

    sh_str1 = shake(0, 0, sh_str1)

    line(0, 8, 127, 8, 6)
    line(0, 8, 32, 8, 1)

    line(32, 7, 32, 9, 1)
    line(95, 7, 95, 9, 1)

    line(95, 8, 127, 8, 1)

    for p in all(particles) do
        p:draw()
    end

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

    local cnt=0
    for fs in all(float_scores) do
        fs:draw(125, 15+9*cnt)
        cnt+=1
    end

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
        h.attacking,
        h.thrown,
    })
end