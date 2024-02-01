function _draw()
    cls(tutorial and 1 or 12)
    if (not tutorial) camera(0+(p_x-50)*0.4, 0+(p_y-50)*0.4)
    rectfill(0,0,127,128,tutorial and 15 or 7)
    map(tutorial and 16 or 0,0,0,0,16,15)

    --print(p_x,p_x+9,p_y-5,0)
    --print(p_y)
    print(sb_wait,0)

    shadow = 0.8

    if pfp_anim then
        a = oval_anim[flr(global_cnt%7/2 + 1)]
        if global_cnt%7 == 6 then
            pfp_anim,pfp=false,true
        end
    end

    ovalfill(pfp_x+a[1], pfp_y+a[2], pfp_x+a[3], pfp_y+a[4], 6)
    ovalfill(pfp_x+a[1]+1, pfp_y+a[2]+1, pfp_x+a[3]-1, pfp_y+a[4]-1, 14)

    if pfp then
        for i=2,29 do
            pset(pfp_x+i, pfp_y+pfp_w/2+sin((i-global_cnt)/10)*3, 13)
            pset(pfp_x+i, pfp_y+pfp_w/2+cos((i+global_cnt)/8)*4, 13)
        end
        sspr(88,0,32,32,pfp_x,pfp_y)
    end

    if not sb then
        rectfill(45,8,119,39,15)
    end

    if sb_start!=0 then
        speech_bubble(50,10,td[sb_current],sb_start)
    end

    if p_spawned then
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

        h_hide = tutorial and sb_current<5

        if not h_held and not h_hide then
            spr(h_current_frame,h_x,h_y+8+h_h,1,shadow,h_flip,true)
        end

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

        if (not h_held and not h_hide) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)
    end

    map((tutorial and 16 or 0),15,0,120,16,2)
end

function speech_bubble(x,y,text,start)
    e = (global_cnt-start)%30000

    if e>#text then
        e=#text
        sb_wait=true
        if (not p_spawned) spr(flr(global_cnt/10)%2==0 and 123 or 124, 110, 30)
    end

    print(sub(text, 1, e), x, y)
end