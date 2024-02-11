function _update()
    if not menu then
        sb_cntr_lim=#d[selected][sb_current]
        sb_ready=sb_cntr==sb_cntr_lim
        p_rolling=p_roll_cntr!=-1
    end
    trans=trans_cntr!=-1

    --c,lim,dec,auto_reset
    outro_cntr=counter_f(outro_cntr,200)

    sb_cntr=counter_f(sb_cntr,sb_cntr_lim)
    sb_auto_cntr=counter_f(sb_auto_cntr,0,true)
    pfp_cntr=counter_f(pfp_cntr,6)

    p_roll_cntr=counter_f(p_roll_cntr,0,true,true)
    p_inv_cntr=counter_f(p_inv_cntr,0,true,true)
    p_combo_cntr=counter_f(p_combo_cntr,0,true,true)
    trans_cntr=counter_f(trans_cntr,50,false,true)

    global_cnt = (global_cnt+1) % 30000 -- these don't current work; go back to if statements!
    anim_cnt = (anim_cnt+1) % 30000

    if (outro_cntr==60) heli_x_target=40
    if (outro_cntr==190) start_trans()

    if heli then
        local diffx,diffy=abs(heli_x-heli_x_target),abs(heli_y-heli_y_target)
        local a=atan2(heli_x-heli_x_target, heli_y-heli_y_target)
        heli_x-=cos(a)*diffx*(outro_cntr==-1 and 0.05 or -0.03)
        heli_y-=sin(a)*diffy*(outro_cntr==-1 and 0.05 or -0.03)

        if intro then
            --p_x,p_y=heli_x,heli_y
        else
            pickup=outro_cntr==-1 and heli_x>=heli_x_target-2 and heli_y>=heli_y_target-2
            if (pickup and pcollide(heli_x+12,heli_y+25,4,3)) pickup,outro_cntr=false,0
        end
    end
    
    c_x=(c_x+c_x_target)/2
    c_y=(c_y+c_y_target)/2

    --was "trans and" before, might have broken something
    if trans_cntr==15 then
        global_cnt=0
        anim_cnt=0
        if page==1 or tutorial and sb_current==17 then
            initialise_menu(2)
        elseif menu and selected==1 then
            menu=false
            initialise_tutorial()
        elseif menu and selected>=2 then
            menu,play=false,true
            initialise_game()
        elseif play and outro_cntr!=-1 then
            initialise_menu(2) -- keeping this separate from the first if for the outro screen
        end
    end

    if splash and anim_cnt==75 then
        splash=false initialise_menu(1)
    elseif menu and not trans then
        if page==1 and btnp(5) then
            start_trans()
        elseif is_in(page, {2,3}) then
            if page==2 then
                if (btnp(0)) selected-=1
                if (btnp(1)) selected+=1
                if (btnp(3)) page=3
                if (selected>#levels) selected=#levels c_x+=3
                if (selected==0) selected=1
                if (btnp(5)) start_trans()
                c_x_target,c_y_target=levels[selected][2]-64,0
            else
                if (btnp(0)) options_selected-=1
                if (btnp(1)) options_selected+=1
                if (btnp(2)) page=2
                if (options_selected>#settings_options) options_selected=1
                if (options_selected==0) options_selected=#settings_options
                if (btnp(5)) settings_options[options_selected][4]=not settings_options[options_selected][4]
                c_x_target,c_y_target=-34,102
            end
        end
    else -- tutorial or play
        if continue!=0 then
            continue-=1
        elseif outro_cntr==-1 then
            if intro then
                p_y+=p_dropping and 2 or 0
                h_y+=h_dropping and 2 or 0

                if (p_y>90) p_dropping=false
                if (h_y>90) h_dropping=false

                if intro_phase==1 then
                    p_x,p_y=heli_x+10,heli_y
                    if heli_x>=42 then
                        intro_phase+=1
                        heli_x_target=64
                        h_dropping=true
                        h_x,y_y=heli_x+10,heli_y+4
                    end
                end

                if intro_phase==2 then
                    p_x,p_y=heli_x+10,heli_y
                    if heli_x>=62 then
                        intro_phase+=1
                        p_dropping=true
                        heli_x_target=200
                    end
                end
                
                if intro_phase==3 then
                    if heli_x>150 then
                        heli,intro,p_spawned=false,false,true
                        heli_x,heli_y,heli_x_target,heli_y_target=-120,50,-120,50
                    end
                else
                    c_x_target,c_y_target=heli_x,heli_y
                end
            end

            if (sb_auto_cntr==0 and sb_current!=17) next_text()

            if (not trans and pfp_cntr==-1 and sb_current==1) pfp_cntr=0
            if (pfp_cntr==6 and sb_cntr==-1) sb_cntr=0

            if not p_spawned then
                if sb_cntr!=-1 and btnp(5) then
                    if sb_ready then
                        next_text()
                        if (tutorial and sb_current==4) p_spawned,c_x_target,c_y_target=true,58,48
                        if (intro and sb_current==5) pfp_cntr,sb_cntr,heli_x_target,heli_y_target=-1,-1,44,64
                    else
                        sb_cntr=sb_cntr_lim
                    end
                end
            elseif not intro then
                if not p_rolling then
                    mx,my,inc=0,0,p_move_speed*(h_held and 0.85 or 1)
                    if (btn(0)) mx=-inc p_flip=true
                    if (btn(1)) mx=inc  p_flip=false
                    if (btn(2)) my=-inc
                    if (btn(3)) my=inc

                    if (sb_current==4 and sb_ready and (mx!=0 or my!=0)) next_text()

                    moved = mx!=0 or my!=0

                    if mx!=0 and my!=0 then
                        mx*=0.75
                        my*=0.75
                    end

                    p_anim = moved and (h_held and 4 or 2) or (h_held and 3 or 1)
                end

                step = p_rolling and 10/2^((p_roll_cntr-11)/-2) or 1
                p_x += mx*step
                p_y += my*step

                if (p_x<bound_xl) p_x=bound_xl
                if (p_x>bound_xu) p_x=bound_xu
                if (p_y<bound_yl) p_y=bound_yl
                if (p_y>bound_yu) p_y=bound_yu

                if (t_rolled and sb_current==14 and sb_ready) next_text()

                h_held = h_v<1 and pcollide(h_x,h_y,h_xw,h_yw)

                if h_held then
                    if sb_current==5 and sb_ready then
                        next_text()
                    elseif sb_current==6 and sb_ready and t_thrown then
                        next_text()
                        create_e()
                        es[1].x=90
                        es[1].y=80
                    end

                    h_x=p_x
                    h_y=p_y

                    if btn(4) and moved then
                        t_thrown=true
                        h_v = 20
                        h_dir = {mx,my}
                        h_flip = p_flip
                        h_h = 10
                    end
                else
                    if btnp(5) and moved and not p_rolling and (not tutorial or sb_current>=14) then
                        t_rolled=true
                        p_roll_cntr,p_anim,anim_cnt,p_inv_cntr = 10,5,1,12
                    end
                end

                if h_v > 0.5 then
                    h_prev_x=h_x
                    h_prev_y=h_y

                    for i=1,4 do
                        h_x+=h_v/4*h_dir[1]
                        h_y+=h_v/4*h_dir[2]

                        for e in all(es) do
                            e:check_hammer_collision()
                        end
                    end

                    h_v*=0.5
                else
                    h_v=0
                end

                if (h_x<bound_xl) h_x=bound_xl h_dir[1]*=-1 h_flip=false
                if (h_x>bound_xu) h_x=bound_xu h_dir[1]*=-1 h_flip=true
                if (h_y<bound_yl) h_y=bound_yl h_dir[2]*=-1
                if (h_y>bound_yu) h_y=bound_yu h_dir[2]*=-1

                if tutorial then
                    if (not trans and sb_current==17 and pcollide(109,85,10,10)) start_trans()
                else
                    if #es != e_conc_limit and e_spawn_cnt<e_wave_cnt then
                        if e_spawn_timer!=e_spawn_interval then
                            e_spawn_timer+=1
                        else
                            create_e()
                            e_spawn_cnt+=1
                            e_spawn_timer=0
                        end
                    end

                    for e in all(es) do
                        e:move()
                        e:check_player_collision()
                    end

                    if e_killed_cnt==e_wave_cnt then
                        if wave < wave_cnt then
                            wave+=1
                            e_wave_cnt=lvl[wave][1]
                            e_spawn_cnt=0
                            e_killed_cnt=0
                            e_conc_limit = lvl[wave][2]
                        else
                            heli=true
                            heli_x_target,heli_y_target=50,50
                        end
                    end

                    
                end

            end
        end

    end
end

function counter_f(c,lim,dec,auto_reset)
    local r=auto_reset and -1 or c
    if (dec) return (c<1) and r or c-1
    return (is_in(c,{-1,lim})) and r or c+1
end

function next_text()
    sb_current+=1
    sb_cntr=0
    sb_auto_cntr=is_in(sb_current, {8,9,10,11,12,13,15,16,17}) and 150 or -1
end

function increase_score(score)
    p_score1+=flr(score*(1+p_combo/10))
    p_combo+=1
    p_combo_cntr=60
    if (p_score1>9999) p_score1-=9999 p_score2+=1
end

function is_in(val, table)
    for elem in all(table) do
        if (val==elem) return true
    end
    return false
end

function start_trans()
    trans_cntr=0
end