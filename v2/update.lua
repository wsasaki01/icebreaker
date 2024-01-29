function _update()
    anim_cnt = anim_cnt+1 % 30000

    if not p_roll then
        mx,my=0,0
        if (btn(0) and p_x>0)   mx=-p_move_speed p_flip=true
        if (btn(1) and p_x<120) mx=p_move_speed  p_flip=false
        if (btn(2) and p_y>0)   my=-p_move_speed
        if (btn(3) and p_y<120) my=p_move_speed

        if mx!=0 and my!=0 then
            mx*=.7
            my*=.7
        end

        p_anim = (mx!=0 or my!=0) and (h_unheld and 2 or 4) or (h_unheld and 1 or 3)
    end

    step = p_roll and 10/2^((p_roll_timer-11)/-2) or 1
    p_x += mx*step
    p_y += my*step

    if p_roll then
        p_roll_timer -= 1
        p_roll = p_roll_timer != 0
    end

    h_unheld = not pcollide(h_x,h_y,h_xw,h_yw)
    if not h_unheld then
        h_x=p_x
        h_y=p_y

        if btn(5) then
            --throw hammer
        end
    else
        if btn(4) and not p_roll then
            p_roll,p_roll_timer,p_anim,anim_cnt = true,10,5,1
        end
    end
end