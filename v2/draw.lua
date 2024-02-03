function _draw()
    if splash then
        cls(0)
        print("(placeholder)",40,60)
    elseif menu then
        cls(12)
        print("icebreaker dx\n❎ for tutorial\n🅾️ to play",30,50,0)
    else
        cls(tutorial and 1 or 12)

        if (not tutorial) camera((p_x-c_x)*0.4, (p_y-c_y)*0.4)
        rectfill(0,0,127,128,tutorial and 15 or 7)
        map(tutorial and 16 or 0,0,0,0,16,15)

        shadow = 0.8

        if tutorial then
            -- tutorial isn't working! something about the ovals

            if t_pfp_anim then
                e=global_cnt-t_pfp_start
                a = oval_anim[flr(e%7/2 + 1)]
                if e%7 == 6 then
                    t_pfp_anim,t_pfp_shown=false,true
                end
            end

            ovalfill(t_pfp_x+a[1], t_pfp_y+a[2], t_pfp_x+a[3], t_pfp_y+a[4], 6)
            ovalfill(t_pfp_x+a[1]+1, t_pfp_y+a[2]+1, t_pfp_x+a[3]-1, t_pfp_y+a[4]-1, 14)

            if t_pfp_shown then
                for i=1,29 do
                    pset(t_pfp_x+i, t_pfp_y+t_pfp_w/2+sin((i-global_cnt)/10)*3, 13)
                    pset(t_pfp_x+i, t_pfp_y+t_pfp_w/2+cos((i+global_cnt)/8)*4, 13)
                end
                sspr(88,0,32,32,t_pfp_x,t_pfp_y)
            end

            if not t_sb_shown then
                rectfill(45,8,119,39,15)
            end

            if t_sb_start!=0 then
                speech_bubble(50,10,td[t_sb_current],13)
            end
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

            h_hide = t_sb_current<5

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

        if not tutorial then
            camera()
            map(32,0,0,0)
            
            sspr(0,32,24,8,3,1)
            if (p_health<=2) spr(69,19,1)
            if (p_health<=1) spr(68,11,1)
            if (p_health<=0) spr(67,3,1)

            wide_print(get_score(),30,3,3)
            wide_print(get_score(),30,2,0)

            print(e_spawn_interval)
            print(e_spawn_timer)
        end
    end
end

function speech_bubble(x,y,text,c)
    e = (global_cnt-t_sb_start)%30000

    if e>#text then
        e=#text
        t_sb_wait=true

        if (not p_spawned) spr(flr(global_cnt/10)%2==0 and 123 or 124, 110, 30)
    end

    print(sub(text, 1, e), x, y)
end

function get_score()
    t=p_score1
    if p_score2!=0 then
        for i=1,4-#tostr(p_score1) do
            t="0"..t
        end
        t=p_score2..t
    end
    return t
end