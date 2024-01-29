function _update()
    anim_cnt += 1
    anim_cnt = anim_cnt % 30000

    if not p_roll then
        moved = {0,0}
        if (btn(0) and p_x>0)   p_x-=1 moved[1]=-1 p_flip=true
        if (btn(1) and p_x<120) p_x+=1 moved[1]=1  p_flip=false
        if (btn(2) and p_y>0)   p_y-=1 moved[2]=-1
        if (btn(3) and p_y<120) p_y+=1 moved[2]=1

        if moved[1]!=0 and moved[2]!=0 then
            moved[1]*=0.7071
            moved[2]*=0.7071
        end

        p_anim = (moved[1]!=0 or moved[2]!=0) and (h_unheld and 2 or 4) or (h_unheld and 1 or 3)
    else
        step = 20/2^((p_roll_timer-11)/-2)
        p_x += moved[1]*step
        p_y += moved[2]*step
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
            p_roll = true
            p_roll_timer = 10
        end
    end
end