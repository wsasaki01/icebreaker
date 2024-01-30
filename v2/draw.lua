function _draw()
    cls(7)
    print()

    p_current_anim = anims[p_anim]
    p_current_frame = p_current_anim[1] + flr(anim_cnt*p_current_anim[3]) % p_current_anim[2]
    
    if h_v > 0.5 then
        h_current_anim = anims[6]
        h_current_frame = h_current_anim[1] + flr(anim_cnt*h_current_anim[3]) % h_current_anim[2]    
        h_h/=2
    else
        h_current_frame = 132
        h_h=0
    end
    
    replace_all_col(6)
    spr(p_current_frame,p_x,p_y+8,1,1,p_flip,true)
    if (not h_held) spr(h_current_frame,h_x,h_y+8+h_h,1,1,h_flip,true)
    pal()

    spr(p_current_frame,p_x,p_y,1,1,p_flip)

    for e in all(es) do
        e:draw()
    end

    if h_v > 0.5 then
        line(h_prev_x+3, h_prev_y+11, h_x+3, h_y+11, 6)
        line(h_prev_x+3, h_prev_y+3, h_x+3, h_y+3, 14)
    end

    if (not h_held) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)
end
