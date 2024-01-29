function _draw()
    cls(7)
    print()


    spr(5,p_x,p_y+1)
    current_anim = anims[p_anim]
    spr(
        current_anim[1] + flr(anim_cnt*current_anim[3]) % current_anim[2],
        p_x,p_y,1,1,p_flip
    )

    if h_v > 0.5 then
        line(h_prev_x+3, h_prev_y+3, h_x+3, h_y+3, 6)
    end

    if (not h_held) spr(128, h_x, h_y)
    
    --rect(p_x,p_y+2,p_x+7,p_y+8)
    --rect(h_x,h_y,h_x+h_xw,h_y+h_yw)
end
