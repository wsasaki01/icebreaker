function _update()
    if menu then
        if btnp(5) then
            menu = false
            play = true
            start_game()
        end
    elseif play then
        -- hitstop
        if hs then
            hs_cnt += 1
            if hs_cnt == hs_frames then
                hs = false
                hs_cnt = 0
            end
        else
            -- difficulty scaling
            if 1000 < p.score and p.score <= 2000 then
                e_cnt = 6
            elseif 2000 < p.score and p.score <= 3000 then
                e_cnt = 8
            elseif 3000 < p.score then
                e_cnt = 10
            end

            -- roll movement
            if p.rolling then
                p:roll()
            else
                diff = p:move()
            end

            -- player functions
            p:die()
            p:cooldown()
            p:sprite()
            p:inv()
            p:combo()

            -- weapon follows player
            if h.equipped then
                h.x = p.x
                h.y = p.y
            else
                -- if dropped, check if overlapping with player
                h:check()
            end


            -- swing or throw
            if btn(5) and not p.rolling then
                -- swing if holding weapon, charged, and not already attacking
                if h.equipped and p.a_charge==true and #attacks<1 then
                    p.a_charge = 0
                    create_attack("player", p_a_len, p_a_size)
                -- roll if not holding weapon and holding direction
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) then
                    p.rolling = true
                    p.i = true
                    p.i_cnt = 9 -- i-frames
                    p.d = atan2(diff.x, diff.y)
                    sfx(3)
                end
            end

            if btn(4) and not p.rolling and h.equipped and (diff.x!=0 or diff.y!=0) then
                h.thrown = true
                h.equipped = false
                h.v = 10
                h.path = diff
                sfx(2)
                create_attack("hammer", h_a_len, h_a_size)
            end

            if h.v < 1 then
                h.thrown = false
                if h.hit_cnt > 3 then
                    create_hit_sign(h.last_hit.x+4, h.last_hit.y+4, h.hit_cnt)
                end
                h.hit_cnt = 0
                h.v = 0
            end

            if h.thrown then
                h.d = atan2(h.path.x, h.path.y)

                local x = h.x+cos(h.d)*h.v
                local y = h.y+sin(h.d)*h.v

                if x>=120 then
                    h.x = 120
                    h.path.x *= -1
                    h.v *= 0.6
                elseif x <= 0 then
                    h.x = 0
                    h.path.x *= -1
                    h.v *= 0.6
                else
                    h.x = x
                end

                if y>=120 then
                    h.y = 120
                    h.path.y *= -1
                    h.v *= 0.6
                elseif y <= 0 then
                    h.y = 0
                    h.path.y *= -1
                    h.v *= 0.6
                else
                    h.y = y
                end

                h.v*=0.8
            end

            if #enemies < e_cnt then
                create_enemy()
            end

            for e in all(enemies) do
                if e.spawn_cnt != 0 then
                    e.spawn_cnt -= 1
                else
                    if 0.8*e_range+e_s_min < e.speed and e.speed < 0.9*e_range+e_s_min then
                        e.s = 18
                    elseif 0.9*e_range+e_s_min < e.speed then
                        e.s = 19
                    else
                        e.s = 2
                    end
                    e:move()
                    e:die()
                end
            end

            for a in all(attacks) do
                if a.type == "player" then
                    a_follow(a, p.x, p.y)
                elseif a.type == "hammer" then
                    a_follow(a, h.x, h.y)
                end

                a:decay()
            end

            for hs in all(hit_signs) do
                hs:decay()
            end
        end
    elseif retry then
        if btn("5") then
            retry_cnt +=1
        else
            retry_cnt = 0
        end

        if retry_cnt == retry_fr then
            retry_cnt = 0
            retry = false
            play = true
            start_game()
        end
    end
end