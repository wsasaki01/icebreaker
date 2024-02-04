function _draw()
    if splash then
        cls(0)
        print("(placeholder)",40,60)


        -- you can hold the button and the transition keeps repeating
        -- also tutorial doesn't trigger after play

    elseif menu then
        if page==1 then
            cls(12)
            print("\#7❎ start",48,90,0)
            print("WSASAKI",1,122,0)
        elseif page==2 then
            cls(13)
            local y=800/(global_cnt-sheet_start)
            if (y<10) y=10
            rectfill(10,y,120,128,7)
            fillp(░)
            line(12,y+2,12,y+500,13)
            fillp()
            print("oPERATION iCEBREAKER\n\|i\f8\#fconfidential\n\n\fd\#7nEW RECRUITS ARE REQUIRED\nTO COMPLETE TRAINING\nBEFORE FIELD DEPLOYMENT.",15,y+2,0)
            
            local cnt=0
            for option in all(menu_options) do
                cnt+=1
                print(option[1],option[2],y+option[3])

                if (cnt==selected) spr(5,option[2]-10,y+option[3]-1)
            end
        end

    else
        cls(tutorial and 1 or 12)

        if (not tutorial) shake(c_x-59+(p_x-c_x)*0.4,c_y-64+(p_y-c_y)*0.4)

        rectfill(0,0,127,128,tutorial and 15 or 7)
        map(tutorial and 16 or 0,0,0,0,16,15)

        shadow = 0.8

        if tutorial then
            if t_pfp_anim then
                e=global_cnt-t_pfp_start
                a = oval_anim[flr(e%7/2 + 2)]
                if e%7 == 6 then
                    t_pfp_anim,t_pfp_shown=false,true
                end
            elseif not t_pfp_shown then
                a=oval_anim[1]
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

            if t_sb_current==12 then
                draw_halo(113,88) print("eVAC",105,86,8)
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
            
            if heli then
                c_x_target,c_y_target=heli_x,heli_y
                generate_wind(heli_x+14,heli_y+35)
                draw_wind(heli_x+14,heli_y+35)

                if pickup then
                    circfill(heli_x+14,heli_y+30,12,7)
                    line(heli_x+14,heli_y+16,heli_x+14,heli_y+26,9)
                    pset(heli_x+14,heli_y+20)
                    draw_halo(heli_x+14,heli_y+30)
                end
            end
            
            replace_all_col(tutorial and 9 or 6)

            if (heli) ovalfill(heli_x+6,heli_y+29,heli_x+22,heli_y+32)
            if outro_start==-1 then
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
            else
                pal()
                local h=2^(4.65-outro_cnt/8)
                line(heli_x+14,heli_y+15,heli_x+14,heli_y+3+h,9)
                spr(1,heli_x+9,heli_y+3+h)
            end
            
            if heli then
                sspr(0,72,24,16,heli_x,heli_y)
                oval(heli_x+6,heli_y-1,heli_x+24,heli_y+5,global_cnt%2==0 and 6 or 13)
                if (global_cnt%2==0) ovalfill(heli_x+6,heli_y-1,heli_x+24,heli_y+5, 6)
            end
        end

        map((tutorial and 16 or 0),15,0,120,16,2)

        if not tutorial then
            camera(0,0)
            map(32,0,0,0)
            
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
                local y=120
                if (big_combo_print!=0) x-=#t*4 y-=5 t="\^w\^t"..t

                print(t,x,y+1,9)
                print(t,x,y,0)
            end

            if e_killed_cnt != e_cnt then
                print("PROGRESS",95,0,13)
                rectfill(95,6,95+30*(e_killed_cnt/e_cnt),8,14)
                line(95,6,95,8,0)
                line(125,6,125,8,0)
            else
                print("evacuate",95,2,global_cnt%30==0 and 8 or 14)
            end
        end
    end

    if trans then
        local p={░,▒,█}
        for i=1,3 do
            local x=128-trans_cnt*25
            fillp(p[i])
            rectfill(x+i*20,0,x+600-i*20,128,0)
        end
        trans_cnt+=1
        trans=trans_cnt<50
    end

    if (big_combo_print!=0) big_combo_print-=1
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