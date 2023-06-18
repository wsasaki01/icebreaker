function _draw()
    if menu then
        cls(14)
        print("icebreaker demo", 20, 50, 12)
        print("❎ to start\n")
        print("high score: "..tostr(h_score), 6)
        print("best combo: "..tostr(h_combo))
    elseif play then
        cls(7)
        camera(0, 0)
    
        print("❎ TO ROLL", 20, 50, 6)
        print("W/ HAMMER: 🅾️ TO THROW\n           ❎ TO SWING")
    
        for i=1,p.health do
            spr(6, i*10-8, 3)
        end

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

        cursor(20, 70, 0)
        log({
            "len "..#hearts
        })
    elseif retry then
        rectfill(20, 30, 100, 80, 2)
        if retry_cnt != 0 then
            rectfill(25, 35, 25+64*(retry_cnt/retry_fr), 41, 13)
        end
        print("hold ❎ to retry", 26, 36, 7)
        print("THIS GAME:", 14)
        print("score:      "..tostr(p.score))
        print("best combo: "..tostr(p.combo_rec))
        print("ALL-TIME:", 12)
        print("high score: "..tostr(h_score))
        print("best combo: "..tostr(h_combo))
    end
end