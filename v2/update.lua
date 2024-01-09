function _update()
    if anim_cnt == 30000 then
        anim_cnt = 0
    else
        anim_cnt += 1
    end

    moved = false
    if (btn(0) and p_x>0)   p_x-=1 moved=true p_flip=true
    if (btn(1) and p_x<120) p_x+=1 moved=true p_flip=false
    if (btn(2) and p_y>0)   p_y-=1 moved=true
    if (btn(3) and p_y<120) p_y+=1 moved=true

    p_anim = moved and (h_unheld and 2 or 4) or (h_unheld and 1 or 3)

    h_unheld = not pcollide(h_x,h_y,h_xw,h_yw)
    if not h_unheld then
        h_x = p_x
        h_y = p_y

        if btn(5) then
            p_anim = 4
        end
    end
end