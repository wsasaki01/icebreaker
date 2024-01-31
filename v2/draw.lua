function _draw()
    cls(tutorial and 1 or 12)
    if (not tutorial) camera(0+(p_x-50)*0.4, 0+(p_y-50)*0.4)
    rectfill(0,tutorial and 50 or 0,127,128,tutorial and 15 or 7)
    map(tutorial and 16 or 0,0,0,0,16,15)

    --print(p_x,p_x+9,p_y-5,0)
    --print(p_y)

    shadow = 0.8

    if sb then
        a = oval_anim[flr(anim_cnt%7/2 + 1)]
        sb = anim_cnt%7 != 6
    end

    ovalfill(sb_x+a[1], sb_y+a[2], sb_x+a[3], sb_y+a[4], 6)
    ovalfill(sb_x+a[1]+1, sb_y+a[2]+1, sb_x+a[3]-1, sb_y+a[4]-1, 14)

    if (not sb) sspr(88,0,32,32,sb_x,sb_y)

    if sb_start!=0 then
        speech_bubble(50,10,td[1],sb_start)
    end

    --[[
    if sb then
        sspr(80+(anim_cnt%3*16),40,16,16,sb_x,sb_y,32,32)
        if 80+(anim_cnt%3*16) == 112 then
            sb=false
        end
    else
        ovalfill(sb_x,sb_y+2,sb_x+31,sb_y+32,3)
        ovalfill(sb_x+2,sb_y+4,sb_x+29,sb_y+30,7)
        sspr(88,0,16,16,sb_x,sb_y)
    end
    ]]--

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

    map((tutorial and 16 or 0),15,0,120,16,2)
end

function speech_bubble(x,y,text, start)
    print(sub(text, 1, anim_cnt-start), x, y)
    return (start+1)%30000
end