function _draw()
    if splash then
        cls(0)
        print("(placeholder)",40,60)

        -- also tutorial doesn't trigger after play

    elseif menu then
        if page==1 then
            cls(12)
            print("\#7❎ start",48,90,0)
            print("WSASAKI",1,122,0)
        elseif is_in(page,{2,3}) then
            cls(0)
            shake(c_x,c_y)

            for i=0,41 do
                for j=0,40 do
                    spr(71,i*8-36,j*8-10)
                end
            end

            draw_hanger_sign(-33,53,8,68)
            print("\f2⬅️➡️\-hselect\n\|h⬇️ \-hoptions",-32,55)

            for i=0,30 do
                for j=0,12 do
                    spr(70,10+i*8,10+j*8)
                end
            end
            line(10,10,257,10,6)
            rectfill(10,113,257,115,1)

            line(30,60,30,60)
            for lvl in all(levels) do
                line(lvl[2],60+lvl[3],2)
            end

            local cnt=0
            for lvl in all(levels) do
                cnt+=1
                spr(108,lvl[2],52+lvl[3])
                replace_all_col(1)
                spr(108,lvl[2],60+lvl[3],1,1,false,true)
                pal()
                if (selected==cnt) print("\#7"..lvl[1],lvl[2]-#lvl[1],64+lvl[3])
            end

            draw_hanger_sign(-29,140,-1,148)
            print("\f0options", -28,142)

            draw_hanger_sign(4,136,45,151)
            print("\f0⬅️➡️\-hselect\n\|h⬆️  \-hreturn",5,138)

            draw_hanger_sign(-27,160,70,201)
            local cnt=0
            for op in all(settings_options) do
                cnt+=1
                print(op[1]..(op[4] and " \#fon" or " \#foff"),op[2],op[3])
                if (options_selected==cnt) spr(5,op[2]-9,op[3])
            end
        end

    else
        cls(tutorial and 4 or 12)

        shake(c_x-59+(p_x-c_x)*0.4,c_y-64+(p_y-c_y)*0.4)

        rectfill(0,tutorial and 64 or 0,127,127,tutorial and 15 or 7)

        if tutorial then
            map(16,8,0,64,16,15)
            if sb_current==17 then
                draw_halo(113,88)
                print("eVAC",105,86,8)
            end
        else
            map(0,0,0,0,16,15)
        end

        shadow = 0.8

        if heli then
            replace_all_col(6)
            clip(6,8,144,114)
            ovalfill(heli_x+6,heli_y+29,heli_x+22,heli_y+32)
            clip()
            pal()

            if (not intro) c_x_target,c_y_target=heli_x,heli_y
            generate_wind(heli_x+14,heli_y+35)
            draw_wind(heli_x+14,heli_y+35)

            if pickup then
                circfill(heli_x+14,heli_y+30,12,7)
                line(heli_x+14,heli_y+16,heli_x+14,heli_y+26,9)
                pset(heli_x+14,heli_y+20)
                draw_halo(heli_x+14,heli_y+30)
            end
        end

        p_current_anim = anims[p_anim]
        p_current_frame = p_current_anim[1] + flr(anim_cnt*p_current_anim[3]) % p_current_anim[2]
        h_current_anim = anims[6]
        h_current_frame = h_current_anim[1] + flr(anim_cnt*h_current_anim[3]) % h_current_anim[2]

        if intro and intro_phase>1 then
            replace_all_col(tutorial and 9 or 6)
            if p_dropping then
                p_current_frame = 16
            else
                spr(p_current_frame,p_x,p_y+8,1,shadow,p_flip,true)
            end

            if not h_dropping then
                h_current_frame = 132
                spr(h_current_frame,h_x,h_y+8+h_h,1,shadow,h_flip,true)
            end
            pal()

            if (intro_phase>=2) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)
            if (intro_phase>=3) spr(p_current_frame,p_x,p_y,1,1,p_flip)
        end

        if p_spawned then
            if h_v > 0.5 then
                h_h/=2
            else
                h_current_frame = 132
                h_h=0
            end
            
            replace_all_col(tutorial and 9 or 6)

            if outro_cntr==-1 then
                spr(p_current_frame,p_x,p_y+8,1,shadow,p_flip,true)

                h_hide = sb_current<5

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
                    if (shadow>0.4) line(h_prev_x+3, h_prev_y+11, h_x+3, h_y+11, tutorial and 9 or 6)
                    line(h_prev_x+3, h_prev_y+3, h_x+3, h_y+3, 2)
                end

                if (not h_held and not h_hide) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)
            else
                pal()
                local h=2^(4.65-outro_cntr/8)
                line(heli_x+14,heli_y+15,heli_x+14,heli_y+3+h,9)
                spr(1,heli_x+9,heli_y+3+h)
            end
        end

        if heli then
            sspr(0,72,24,16,heli_x,heli_y)
            oval(heli_x+6,heli_y-1,heli_x+24,heli_y+5,global_cnt%2==0 and 6 or 13)
            if (global_cnt%2==0) ovalfill(heli_x+6,heli_y-1,heli_x+24,heli_y+5, 6)
        end

        map((tutorial and 16 or 0),15,0,120,16,2)

        camera()
        map(16,0,0,0,16,2)

        if pfp_cntr !=-1 and (tutorial or intro) then
            a = oval_anim[(not trans) and flr(pfp_cntr/2 + 2) or 1]

            ovalfill(pfp_x+a[1], pfp_y+a[2], pfp_x+a[3], pfp_y+a[4], 6)
            ovalfill(pfp_x+a[1]+1, pfp_y+a[2]+1, pfp_x+a[3]-1, pfp_y+a[4]-1, 14)

            if pfp_cntr==6 then
                for i=1,29 do
                    pset(pfp_x+i, pfp_y+pfp_w/2+sin((i-global_cnt)/10)*3, 13)
                    pset(pfp_x+i, pfp_y+pfp_w/2+cos((i+global_cnt)/8)*4, 13)
                end
                sspr(88,0,32,32,pfp_x,pfp_y)
            end

            if sb_cntr!=-1 then
                speech_bubble(39,22,d[selected][sb_current],13)
            end
        end
        
        shake(0,0)
        sspr(0,32,24,8,3,1)
        if (p_health<=2) spr(69,19,1)
        if (p_health<=1) spr(68,11,1)
        if (p_health<=0) spr(67,3,1)

        wide_print(get_score(),30,3,3)
        wide_print(get_score(),30,2,0)

        if p_combo>0 then
            local t="X"..p_combo
            local x=122-4*#tostr(p_combo)
            local y=119
            if (big_combo_print!=0) x-=#t*4 y-=5 t="\^w\^t"..t

            print(t,x,y+1,9)
            print(t,x,y,0)

            if (not heli) rectfill(128-128*p_combo_cntr/60,126,128,127,8)
        end

        if not tutorial then
            if e_killed_cnt != e_wave_cnt then
                print("PROGRESS",95,0,13)
                rectfill(95,6,95+30*(e_killed_cnt/e_wave_cnt),8,14)
                line(95,6,95,8,0)
                line(125,6,125,8,0)
            else
                print("evacuate",95,2,global_cnt%30==0 and 8 or 14)
            end
        end
    end

    if trans then
        camera(0,0)
        local p={░,▒,█}
        for i=1,3 do
            local x=128-trans_cntr*25
            fillp(p[i])
            rectfill(x+i*20,0,x+600-i*20,128,0)
        end
    end

    if (big_combo_print!=0) big_combo_print-=1

    print(p_dropping,1,1,0)
    if (play) print(p_x.." "..p_y)
end

function speech_bubble(x,y,text,c)
    map(16,2,x,y,10,4)

    if sb_cntr>=#text then
        sb_cntr=#text
        if (not p_spawned) spr(123 + global_cnt\10%2, x+71, y+22)
    end

    print(sub(text, 1, sb_cntr), x+10, y+2)
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

function generate_wind(cx,cy)
    for i=1,3 do
        if #wind != 200 then
            add(wind, {cx-10+rnd(20),cy-10+rnd(20),rnd(1)>0.5 and 6 or 6})
        end
    end
end

function draw_wind(cx,cy)
    for w in all(wind) do
        local ow1,ow2=w[1],w[2]

        local d=sqrt((cx-ow1)^2 + (cy-ow2)^2)
        if d>80 or not within_bounds(ow1,ow2) then
            del(wind,w)
        else
            local a=atan2(cx-ow1, cy-ow2)
            w[1]-=cos(a)*50/d
            w[2]-=sin(a)*50/d
            local w1,w2=w[1],w[2]
            if (within_bounds(w1,w2))line(ow1,ow2,w1,w2,w[3])
        end
    end
end

function draw_halo(cx,cy)
    local theta=(global_cnt%100+1)/50
    for i=0,3 do
        for j=0,1 do
            local x,y=cx+10*cos(theta+i/4+j/100),cy+6*sin(theta+i/4+j/100)
            pset(x,y,8+j*6)
        end
    end
end

function draw_hanger_sign(x1,y1,x2,y2)
    circfill((x2+x1)/2,y1-4,1,6)
    local a=(x2-x1)*0.15
    line(x1+a,y1,(x2+x1)/2,y1-4,8)
    line(x2-a,y1,(x2+x1)/2,y1-4)
    rectfill(x1,y1,x2,y2,9)
end