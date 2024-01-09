function _update()
    if (btn(0) and p_x > 0)   p_x -= 1
    if (btn(1) and p_x < 120) p_x += 1
    if (btn(2) and p_y > 0)   p_y -= 1
    if (btn(3) and p_y < 120) p_y += 1

    if (p_anim_cnt == 0 and p_anim == 1) p_anim_cnt = 4

    if p_anim_cnt != 0 then
        p_anim_cnt -= 1
    end

    if h_unheld then
        if (pcollide(h_x,h_y,h_xw,h_yw)) h_unheld = false
    else
        h_x = p_x
        h_y = p_y

        if btn(5) then
            p_anim_cnt = 4
        end
    end
end