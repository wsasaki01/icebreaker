function _update()
    if retry or finished then
        retry_cnt=btn(5) and retry_cnt+1 or 0

        if retry_cnt == retry_fr then
            retry_cnt = 0
            play,retry,finished = true,false,false
            start_game()
        end

        return_cnt=btn(4) and return_cnt+1 or 0

        if return_cnt == return_fr then
            return_cnt = 0
            play,retry,finished,hub=false,false,false,true

            unlocked=dget(2)
            gen_lvl_info()
            gen_btns()
            reset_tbls()
            menu_c={pack=false,lvl=false}
            p = create_player(menu_op.h_type, menu_op.mod)
            h.equipped=false
        end
    else
        -- hitstop
        if hs != 0 then
            hs-=1
        else
            fr+=1
            if fr==32767 then
                fr-=32767
                p.roll_fr_start-=32767
            end

            if hub or config then
                for button_type_list in all(buttons) do
                    for button in all(button_type_list) do
                        button:check()
                    end
                end

                local collide_left=pcollide(
                    20,100,16,10
                )
                local collide_right=pcollide(
                    36,100,15,10
                )

                if unlocked >= 8 then
                    if collide_left and not collide_right and endless then
                        endless=false
                        sfx(17)
                    elseif collide_right and not collide_left and not endless then
                        endless=true
                        sfx(17)
                    end
                end
            end

            starter:check()

            if not transition and
            (collide(
                p.x,p.y+6,p.xw,p.yw-6,
                124,51,1,27
            ) and hub) or

            (collide(
                p.x,p.y+6,p.xw,p.yw-6,
                130,51,1,27
            ) and config) then
                transition=true
                p.rolling,p.roll_cooldown,p.roll_cnt=false,false,0
            end

            if transition then
                tran_cnt+=hub and 1 or -1
                if (hub and tran_cnt==tran_fr) or (config and tran_cnt==0) then
                    transition=false
                    hub=not hub
                    config=not config
                end
            end

            if play then
                cont:check_wave()
                cont:spawn_enemies()
                cont:check_totem()
            end

            if not btn(5) and x_stick then
                x_stick = false
            end

            if not btn(4) and o_stick then
                o_stick = false
            end

            -- roll movement
            if p.rolling then
                p:roll()
            else
                diff = p:move()
                p.d=atan2(diff.x, diff.y)
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
                    create_attack(p.a_len, p.a_size)
                -- roll if not holding weapon and holding direction
                elseif not h.equipped and (diff.x!=0 or diff.y!=0) and not x_stick then
                    p.rolling = true
                    p.i = true
                    p.i_cnt += 9 -- i-frames
                    p.roll_fr_start = fr
                    x_stick = true
                    sfx(3)
                end
            end

            -- throw, recall or teleport
            if btn(4) and not p.rolling and not (hub or config) then
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

            h.attacking = (h.type!=2 and h.thrown) or (h.type==2 and h.thrown and h.v < 1.5 and h.magnet_v > h_magnet_v_min)

            -- move hammer when thrown
            h:move()

            for e in all(enemies) do
                e:spawn()
                if e.spawn_cnt==e.spawn_fr then
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

            for p in all(particles) do
                p:update()
            end

            if #particles > max_particles then
                del(particles, particles[1])
            end

            for crack in all(cracks) do
                crack:decay()
            end
        end
    end
end