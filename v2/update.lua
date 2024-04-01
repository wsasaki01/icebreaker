function _update()
    if (throw_hold and not btn((menu or pfp_cntr!=-1) and 4 or throw_btn)) throw_hold=false
    if (roll_hold and not btn((menu or pfp_cntr!=-1) and 5 or roll_btn)) roll_hold=false

    lvl_id,trans=selected[1],trans_cntr!=-1

    if not (menu or stats) then
        sb_cntr_lim=#d[lvl_id][sb_current]
        sb_ready,p_rolling=sb_cntr==sb_cntr_lim,p_roll_cntr!=-1
    end

    --c,lim,dec,auto_reset
    outro_cntr=counter_f(outro_cntr,200)

    sb_cntr=counter_f(sb_cntr,sb_cntr_lim)
    sb_auto_cntr=counter_f(sb_auto_cntr,0,true)
    pfp_cntr=counter_f(pfp_cntr,6)

    p_roll_cntr=counter_f(p_roll_cntr,0,true,true)
    p_inv_cntr=counter_f(p_inv_cntr,0,true,true)
    p_combo_cntr=counter_f(p_combo_cntr,0,true,true)
    trans_cntr=counter_f(trans_cntr,50,false,true)
    stamp_cntr=counter_f(stamp_cntr,90,false,true)
    checkm_cntr=counter_f(checkm_cntr,30,false,true)

    global_cnt = (global_cnt+1) % 30000 -- these don't current work; go back to if statements!
    anim_cnt = (anim_cnt+1) % 30000

    if (outro_cntr==60) heli_x_target=40
    if (outro_cntr==190) pfp_cntr,p_spawned=0,false

    if heli then
        generate_dwash(heli_x+14,heli_y+35)
        if (outro_cntr!=-1) c_x_target,c_y_target=heli_x,heli_y
        
        local diffx,diffy=abs(heli_x-heli_x_target),abs(heli_y-heli_y_target)
        local a=atan2(heli_x-heli_x_target, heli_y-heli_y_target)
        local x=(not outro and 0.05 or -0.03)
        heli_x-=cos(a)*diffx*x
        heli_y-=sin(a)*diffy*x

        if not intro then
            pickup=not outro and heli_x>=heli_x_target-2 and heli_y>=heli_y_target-2
            if (pickup and pcollide(heli_x+12,heli_y+25,4,3)) pickup,outro,outro_cntr=false,true,0
        end
    end
    
    --c_x,c_y=(c_x+c_x_target)/2,(c_y+c_y_target)/2

    c_x+=(c_x_target-c_x)*0.25
    c_y+=(c_y_target-c_y)*0.25

    if trans_cntr==15 then
        global_cnt,anim_cnt=0,0
        if page==1 or stats then
            initialise_menu(2)
            intro=false
        elseif menu then
            menu,play=false,true
            initialise_game()
        elseif play and outro_cntr!=-1 then
            play,outro,stats=false,false,true
            stats,sheet_y=true,0
        end
    end

    if splash and anim_cnt==75 then
        splash=false
        initialise_menu(1)
    elseif menu then
        c_x_target,c_y_target = 12*selected[menu_lvl]-35,(menu_lvl-1)*63
        if (menu_lvl==3) c_x_target,c_y_target=-23,170

        drawer_x_target[1]=menu_lvl==1 and 12*#levels+20 or 0
        drawer_x_target[2]=menu_lvl==2 and 60 or 0

        local dx,dmx=drawer_x[menu_lvl],drawer_x_target[menu_lvl]

        expand_page_y+=(expand_page_yt-expand_page_y)*0.15
        if (abs(expand_page_yt-expand_page_y)<1) expand_page_y=expand_page_yt

        if not trans then
            if page_detail then
                c_y_target=-63

                if btnp(4) and stamp_cntr==-1 then
                    page_detail=false
                    expand_page_yt=0
                end

                if btn(5) then
                    confirm+=1
                    if (confirm==30) stamp_cntr=0
                elseif confirm<30 then
                    confirm=0
                end

                if (confirm>30) confirm=30

                if stamp_cntr==10 then
                    sh_str+=0.75
                elseif stamp_cntr==35 then
                    start_trans()
                end
            else
                if (btnp(2)) menu_lvl-=1
                if (btnp(3)) menu_lvl+=1
                if (menu_lvl==0) menu_lvl=3
                if (menu_lvl==4) menu_lvl=1
                
                if dx==dmx then
                    page_y = page_y/2+10
                    if (btnp(0)) selected[menu_lvl]-=1 page_y=0 confirm=0
                    if (btnp(1)) selected[menu_lvl]+=1 page_y=0 confirm=0
                    local sel,limit=selected[menu_lvl],menu_lvl==1 and #levels or menu_lvl==2 and 1 or 6
                    if (sel>limit) selected[menu_lvl]=limit page_y=30
                    if (sel==0) selected[menu_lvl]=1 page_y=30

                    local sel=selected[menu_lvl]

                    if btn(5) and not roll_hold then
                        if menu_lvl==1 then
                            page_detail=true
                            expand_page_yt=-55
                            expand_page_y=0
                        else
                            roll_hold=true
                            if sel==1 then
                                local switch=throw_btn==5 and -1 or 1
                                throw_btn+=switch
                                roll_btn-=switch
                            elseif sel==2 then
                                shake_enabled=not shake_enabled
                            elseif sel==3 then
                                cam_enabled=not cam_enabled
                            elseif sel==4 then
                                acc_lock=not acc_lock
                            elseif sel==5 and not acc_lock then
                                game_speed=game_speed==1 and 0.5 or 1
                            elseif sel==6 and not acc_lock then
                                invincible=not invincible
                            end
                            refresh_settings()
                        end
                    end
                end
            end
        end

        for i=1,2 do
            drawer_x[i]+=(drawer_x_target[i]-drawer_x[i])/3
            if (abs(drawer_x_target[i]-drawer_x[i])<1) drawer_x[menu_lvl]=drawer_x_target[menu_lvl]
        end
    elseif stats then
        if sheet_y>=127 then
            sheet_y=128
            if (btnp"5") start_trans()
        else
            sheet_y+=(133-sheet_y)*0.05
            if (btnp"5") sheet_y=128
        end
    else -- play
        if (pfp_cntr==6 and sb_cntr==-1) sb_cntr=0

        if continue!=0 then
            continue-=1
        elseif outro then
            p_x,p_y=heli_x+60,heli_y-40
            if (heli_x>200) heli_x,heli_y=200,50
            btn_for_sb()
        else
            if intro then
                p_y+=p_dropping and 2 or 0
                h_y+=h_dropping and 2 or 0

                if (p_y>90) p_dropping=false
                if (h_y>90) h_dropping=false

                if intro_phase==1 then
                    p_x,p_y=heli_x+10,heli_y
                    if heli_x>=42 then
                        intro_phase+=1
                        heli_x_target=74 --64
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
                        if is_in(lvl_id,{1}) then
                            pfp_cntr=0
                            sb_auto_cntr=100
                        else
                            dpause=false
                        end
                    end
                else
                    c_x_target,c_y_target=heli_x,heli_y
                end
            end

            if (sb_auto_cntr==0) next_text()

            if (not trans and pfp_cntr==-1 and sb_current==1) pfp_cntr=0

            if not p_spawned then
                btn_for_sb()
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
                    p_x+=cos(kickback_dir)*h_mag_v*1.1
                    p_y+=sin(kickback_dir)*h_mag_v*1.1
                end

                if h_held then
                    --[[
                    if sb_current==5 and sb_ready then
                        next_text()
                    elseif sb_current==6 and sb_ready and t_thrown then
                        next_text()
                        create_e()
                        es[1].x=90
                        es[1].y=80
                    end
                    --]]

                    h_x,h_prev_x=p_x,p_x
                    h_y,h_prev_y=p_y,p_y

                    if btnh(throw_btn) and moved then
                        t_thrown=true
                        h_v = 40
                        h_mag_v = 0
                        h_dir = {mx,my}
                        h_flip = p_flip
                        h_h = 10
                    end
                else
                    if btnh(roll_btn) and moved and not p_rolling then
                        t_rolled=true
                        p_roll_cntr,p_anim,anim_cnt,p_inv_cntr = 10,5,1,12
                    end

                    new_h_x,new_h_y=h_x,h_y
                    h_prev_x=h_x
                    h_prev_y=h_y

                    if h_type==2 and btn(throw_btn) and h_v<2 then
                        h_mag_v+=1.5
                        throw_hold=true
                    end

                    kickback_dir=atan2(p_x-h_x,p_y-h_y)
                    new_h_x+=cos(kickback_dir)*h_mag_v
                    new_h_y+=sin(kickback_dir)*h_mag_v

                    new_h_x+=h_dir[1]*h_v
                    new_h_y+=h_dir[2]*h_v

                    local step_x,step_y=(new_h_x-h_x)/4,(new_h_y-h_y)/4

                    for i=1,4 do
                        h_x+=step_x
                        h_y+=step_y

                        for e in all(es) do
                            e:check_hammer_collision()
                        end
                    end
                end

                h_v *= 0.5
                h_mag_v *= 0.8

                if (h_v<0.5) h_v=0
                if (h_mag_v<1) h_mag_v=0

                if (h_x<bound_xl) h_x=bound_xl h_dir[1]*=-1 h_flip=false
                if (h_x>bound_xu) h_x=bound_xu h_dir[1]*=-1 h_flip=true
                if (h_y<bound_yl) h_y=bound_yl h_dir[2]*=-1
                if (h_y>bound_yu) h_y=bound_yu h_dir[2]*=-1

                if lvl_id==1 then
                    if sb_current==8 then
                        if (pcollide(25,64,6,6) and not tt_move1) tt_move1=true
                        if (pcollide(63,30,6,6) and not tt_move2) tt_move2=true
                        if (pcollide(102,64,6,6) and not tt_move3) tt_move3=true

                        if (tt_move1 and tt_move2 and tt_move3 and checkm_cntr==-1) checkm_cntr=0
                        if (checkm_cntr==30) next_text()
                    elseif sb_current==12 then
                        if (h_held and checkm_cntr==-1) checkm_cntr=0
                        if (checkm_cntr==30) next_text()
                    elseif sb_current==13 then
                        if (not h_held and h_v==0 and checkm_cntr==-1) checkm_cntr=0
                        if (checkm_cntr==30) next_text()
                    elseif sb_current==17 then
                        dpause=false
                        if (wave==2and checkm_cntr==-1) dpause,checkm_cntr=true,0
                        if (checkm_cntr==30) next_text()
                    elseif sb_current==21 then
                        dpause=false
                    end
                end

                if (e_alive_cnt<0) e_alive_cnt=0

                if not dpause and e_alive_cnt < e_conc_limit and e_spawn_cnt<e_wave_cnt then
                    if e_spawn_timer!=e_spawn_interval then
                        e_spawn_timer+=1
                    else
                        create_e()
                        e_spawn_cnt+=1
                        e_spawn_timer=0
                    end
                end

                for proj in all(proj_buffer) do
                    for i=1,4 do
                        create_proj(proj[1],proj[2],i*0.25-0.25)
                    end
                    del(proj_buffer,proj)
                end

                for e in all(es) do
                    e:move()
                    e:check_player_collision()
                end

                if e_killed_cnt==e_wave_cnt then
                    if wave < wave_cnt then
                        increment_wave()
                    else
                        heli=true
                        heli_x_target,heli_y_target=50,50
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
    --sb_auto_cntr=is_in(sb_current, {8,9,10,11,12,13,15,16,17}) and 150 or -1

    local prev_mode,msg=sb_mode,d[lvl_id][sb_current]
    sb_mode=msg=="1" and 1 or msg=="2" and 2 or msg=="3" and 3 or sb_mode

    sb_auto_cntr=p_spawned and sb_mode==1 and 150 or -1

    if sb_mode==3 then
        sb_mode,pfp_cntr,sb_cntr,heli_x_target,heli_y_target=1,-1,-1,64,84 --44,64
        sb_current+=1
    elseif prev_mode!=sb_mode then
        next_text()
    end
end

function btn_for_sb()
    if sb_cntr!=-1 and btnh(5) then
        if sb_ready then
            if outro and sb_current==#d[lvl_id] then
                start_trans()
            else
                next_text()
            end
        else
            sb_cntr=sb_cntr_lim
        end
    end
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
    if (not trans) trans_cntr=0
end

function increment_wave()
    dpause=true
    wave+=1
    local wave_data=lvl[wave]
    e_wave_cnt=0
    e_wave_quota={}
    for i=2,4 do
        local x=wave_data[i]
        e_wave_cnt+=x
        add(e_wave_quota,x)
    end
    e_spawn_cnt=0
    e_alive_cnt=0
    e_killed_cnt=0
    e_conc_limit = wave_data[1]
end