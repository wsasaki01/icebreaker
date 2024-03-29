function _update()
    if menu then
        if btnp(0) then
            if mc==1 then
                if menu_op.h_type != 1 then
                    menu_op.h_type-=1
                else
                    menu_op.h_type=#h_types
                end
            elseif mc==2 then
                if menu_op.mod != 1 then
                    menu_op.mod-=1
                else
                    menu_op.mod=#mods
                end
            end
        end

        if btnp(1) then
            if mc==1 then
                if menu_op.h_type != #h_types then
                    menu_op.h_type+=1
                else
                    menu_op.h_type=1
                end
            elseif mc==2 then
                if menu_op.mod != #mods then
                    menu_op.mod+=1
                else
                    menu_op.mod=1
                end
            end
        end

        if btnp(2) then
            if mc != 1 then
                mc-=1
            else
                mc=menu_op_len
            end
        end

        if btnp(3) then
            if mc != menu_op_len then
                mc += 1
            else
                mc=1
            end
        end

        if btn(5) then
            start_cnt += 1
        else
            start_cnt = 0
        end

        if start_cnt == start_fr then
            start_cnt = 0
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
            fr+=1
            if (fr==32767) fr=0

            if not btn(5) and x_stick then
                x_stick = false
            end

            if not btn(4) and o_stick then
                o_stick = false
            end

            -- difficulty scaling
            if rng(3, 9) then
                e_cnt = 3
            elseif rng(9, 16) then
                e_cnt = 4
            elseif rng(16, 30) then
                e_cnt = 6
            elseif rng(30, 45) then
                e_cnt = 7
            elseif rng(45, 75) then
                e_cnt = 9
            elseif 75 < p.kill_cnt then
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
            p.tpdata={false}

            -- weapon follows player
            if h.equipped then
                h.x = p.x+p.xw/2-h.xw/2
                h.y = p.y+p.yw/2-h.yw/2
            else
                -- if dropped, check if overlapping with player
                h:check()
            end

            -- swing or roll
            if btn(5) and not p.rolling then
                -- swing if holding weapon, charged, and not already attacking
                if h.equipped and p.a_charge==true and #attacks<1 then
                    p.a_charge = 0
                    create_attack("player", p.a_len, p.a_size)
                -- roll if not holding weapon and holding direction
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) and not x_stick then
                    p.rolling = true
                    p.i = true
                    p.i_cnt = 9 -- i-frames
                    p.d = atan2(diff.x, diff.y)
                    x_stick = true
                    sfx(3)
                end
            end

            -- throw, recall or teleport
            if btn(4) and not p.rolling then
                if h.equipped and (diff.x!=0 or diff.y!=0) and not o_stick then
                    h:throw()
                    o_stick=true
                elseif not h.equipped then
                    if h.type==2 then
                        h.magnet_v*=magnet_multi*(1/sqrt((p.x-h.x)^2 + (p.y-h.y)^2)+1)
                        if (h.magnet_v > h_magnet_v_max) h.magnet_v = h_magnet_v_max
                        sfx(6)
                        o_stick = true
                    elseif h.type==3 and h.v < 1.5 and not o_stick then
                        p:tp()
                        o_stick=true
                    end
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
                    a:follow()
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
        if btn(5) then
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

        if btn(4) then
            return_cnt +=1
        else
            return_cnt = 0
        end

        if return_cnt == return_fr then
            return_cnt = 0
            play=false
            menu=true
        end
    end
end