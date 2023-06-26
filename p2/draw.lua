function _draw()
    if menu then
        cls(1)
        print("\^i\^t\^wicebreaker demo", 5, 5, 12)
        print("->", 5, 20+18*(mc-1), 7)
        print("hAMMER:\t⬅️ "..h_types[menu_op.h_type].name.." ➡️", 15, 20, mc==1 and 7 or 12)
        print(h_types[menu_op.h_type].desc.."\n", 48, 26)
        print("mOD:\t\t⬅️ "..mods[menu_op.mod].name.." ➡️", 15, 38, mc==2 and 7 or 12)
        if (menu_op.mod!=0) print(mods[menu_op.mod].desc.."\n", 48, 44)

        if (start_cnt != 0) rectfill(14, 79, 14+44*start_cnt/start_fr, 85, 7)
        print("\n❎ to start\n", 15, 74, 12)
        print("high score: "..tostr(remove_zero(h_score)), 6)
        print("best combo: "..tostr(h_combo))
    elseif play then
        cls(7)
        camera(0, 0)
    
        print("❎ TO ROLL", 20, 50, 6)
        print("W/ HAMMER: 🅾️ TO THROW\n           ❎ TO SWING")

        for hs in all(hit_signs) do
            hs:draw()
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
            spr(6, i*10-8, 3)
        end

        cursor(20, 70, 0)
        log({
        })
    elseif retry then
        rectfill(20, 30, 100, 80, 2)
        if retry_cnt != 0 then
            rectfill(25, 35, 25+64*(retry_cnt/retry_fr), 41, 13)
        end
        print("hold ❎ to retry", 26, 36, 7)
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