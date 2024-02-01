function _update()
    global_cnt = global_cnt+1 % 30000
    anim_cnt = anim_cnt+1 % 30000

    if splash and anim_cnt==75 then
        splash,menu=false,true
    elseif menu then
        if (btnp(5)) menu,tutorial=false,true
        if (btnp(4)) menu,play=false,true initialise_game(40,80,80,80,5)
    elseif tutorial or play then
        if sb_wait_timer!=0 then
            sb_wait_timer-=1
        elseif sb_current==8 or sb_current==10 then
            next_text()
            if (sb_current==11) sb_wait_timer=180
        elseif sb_current==11 then
            tutorial,menu=false,true
        end

        if not p_spawned and tutorial and not pfp_anim and not sb then
            sb=true
            sb_start=anim_cnt
            sb_wait=false
        end

        if not p_spawned and btnp(4) then
            if sb_wait then
                next_text()
                if (sb_current==4) initialise_game(15,80,105,80,1)
            else
                sb_start-=100
            end
        end

        if p_spawned then
            if not p_roll then
                mx,my,inc=0,0,p_move_speed*p_move_multi
                if (btn(0)) mx=-inc p_flip=true
                if (btn(1)) mx=inc  p_flip=false
                if (btn(2)) my=-inc
                if (btn(3)) my=inc

                if (sb_current==4 and sb_wait and (mx!=0 or my!=0)) next_text()

                moved = mx!=0 or my!=0
                moved_diag = mx!=0 and my!=0

                if moved_diag then
                    mx*=.7
                    my*=.7
                end

                p_anim = moved and (h_held and 4 or 2) or (h_held and 3 or 1)
            end

            step = p_roll and 10/2^((p_roll_timer-11)/-2) or 1
            p_x += mx*step
            p_y += my*step

            if (p_x<bound_xl) p_x=bound_xl
            if (p_x>bound_xu) p_x=bound_xu
            if (p_y<bound_yl) p_y=bound_yl
            if (p_y>bound_yu) p_y=bound_yu

            if p_roll then
                p_roll_timer -= 1
                p_roll = p_roll_timer != 0
                if (tutorial and sb_current==9 and sb_wait and not p_roll) next_text() sb_wait_timer=200
            end

            h_held = h_v<1 and pcollide(h_x,h_y,h_xw,h_yw)
            p_move_multi = h_held and 0.85 or 1
            if h_held then
                if sb_current==5 and sb_wait then
                    next_text() tt_thrown=false
                elseif sb_current==6 and sb_wait and tt_thrown then
                    next_text()
                    create_e()
                    es[1].x=90
                    es[1].y=80
                end

                h_x=p_x
                h_y=p_y

                if btn(4) and moved then
                    tt_thrown=true
                    h_v = 20
                    h_dir = {mx,my}
                    h_flip = p_flip
                    h_h = 10
                end
            else
                if btnp(5) and moved and not p_roll and (not tutorial or sb_current>=9) then
                    p_roll,p_roll_timer,p_anim,anim_cnt = true,10,5,1
                end
            end

            if h_v > 0.5 then
                h_prev_x=h_x
                h_prev_y=h_y

                for i=1,4 do
                    h_x+=h_v/4*h_dir[1]
                    h_y+=h_v/4*h_dir[2]

                    for e in all(es) do
                        e:check_collision()
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

            if not tutorial then
                while #es != e_cnt do
                    create_e()
                end

                for e in all(es) do
                    e:move()
                end
            end
        end
    end
end

function next_text()
    sb_current+=1
    sb_start,sb_wait=anim_cnt,false
end

function increase_score(score)
    p_score1+=flr(score*(1+p_combo/10))
    p_combo+=1
    if (p_score1>9999) p_score1-=9999 p_score2+=1
    if (p_score2>9999) p_score2-=9999 p_score3+=1
end