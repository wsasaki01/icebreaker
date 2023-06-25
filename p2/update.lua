function _update()
    if menu then
        if btnp(0) then
            if h_type != 1 then
                h_type-=1
            else
                h_type=h_type_no
            end
        end

        if btnp(1) then
            if h_type != h_type_no then
                h_type+=1
            else
                h_type=1
            end
        end

        if btnp(5) then
            menu = false
            play = true
            start_game()
        end
    elseif play then
        -- hitstop
        if hs != 0 then
            hs_cnt += 1
            if hs_cnt == hs then
                hs = 0
                hs_cnt = 0
            end
        else
            if not btn(5) and roll_stick then
                roll_stick = false
            end

            if not btn(4) and throw_stick then
                throw_stick = false
            end

            -- difficulty scaling
            if 200 < p.score and p.score <= 500 then
                e_cnt = 3
            elseif 1000 < p.score and p.score <= 1500 then
                e_cnt = 4
            elseif 1500 < p.score and p.score <= 2000 then
                e_cnt = 6
            elseif 2000 < p.score and p.score <= 3500 then
                e_cnt = 7
            elseif 3500 < p.score and p.score <= 4000 then
                e_cnt = 9
            elseif 4000 < p.score then
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

            -- swing or roll
            if btn(5) and not p.rolling then
                -- swing if holding weapon, charged, and not already attacking
                if h.equipped and p.a_charge==true and #attacks<1 then
                    p.a_charge = 0
                    create_attack("player", p_a_len, p_a_size)
                -- roll if not holding weapon and holding direction
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) and not roll_stick then
                    p.rolling = true
                    p.i = true
                    p.i_cnt = 9 -- i-frames
                    p.d = atan2(diff.x, diff.y)
                    roll_stick = true
                    sfx(3)
                end
            end

            -- throw
            if btn(4) and not p.rolling then
                if h.equipped and (diff.x!=0 or diff.y!=0) and not throw_stick then
                    h:throw()
                elseif not h.equipped then
                    h.magnet_v*=magnet_multi*(1/sqrt((p.x-h.x)^2 + (p.y-h.y)^2)+1)
                    throw_stick = true
                end
            end

            -- move hammer when thrown
            h:move()

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
                if a.type == 0 then
                    a_follow(a, p.x, p.y)
                end

                a:decay()
            end

            for hs in all(hit_signs) do
                hs:decay()
            end

            for heart in all(hearts) do
                heart:check()
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