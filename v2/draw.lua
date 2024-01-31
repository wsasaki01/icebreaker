function _draw()
    cls(12)
    if (not tutorial) camera(0+(p_x-50)*0.4, 0+(p_y-50)*0.4)
    rectfill(0,0,127,128,7)
    map(0+(tutorial and 16 or 0),0,0,0,16,15)

    --print(p_x,p_x+9,p_y-5,0)
    --print(p_y)

    shadow = 0.8

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
    spr(p_current_frame,p_x,p_y+8,1,shadow,p_flip,true)
    if (not h_held) spr(h_current_frame,h_x,h_y+8+h_h,1,shadow,h_flip,true)
    for e in all(es) do
        e:draw(true)
    end
    pal()

    spr(p_current_frame,p_x,p_y,1,1,p_flip)

    for e in all(es) do
        e:draw(false)
    end

    if h_v > 0.5 then
        if (shadow>0.4) line(h_prev_x+3, h_prev_y+11, h_x+3, h_y+11, 6)
        line(h_prev_x+3, h_prev_y+3, h_x+3, h_y+3, 2)
    end

    if (not h_held) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)

    map(0,15,0,120,16,2)
end
