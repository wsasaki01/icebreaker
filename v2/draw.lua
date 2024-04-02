function _draw()
    if splash then
        cls(0)
        print("(placeholder)",40,60)

    elseif menu then
        cls(7)
        shake(c_x,c_y)

        rectfill(-200,50,50,185,13) --frame

        draw_drawer(drawer_x[1],0,selected[1],true)
        draw_drawer(drawer_x[2],62,selected[2],false)

        rectfill(-200,50,-22,185,1) --cabinet shadow
        line(-22,50,-22,185,0) --shadow outline

        rectfill(-21,50,-18,185,13) -- depth blocker

        for table_cnt=1,15 do --table
            spr(70,table_cnt*8-31,186)
            spr(71,81,185+table_cnt*8)
        end

        rectfill(-200,286,300,300,5) --floor

        sspr(72,72,24,24,-15,262) --settings box
        print("⬅️\-hnavigate\-h➡️\n❎\-hselect",163,170,9)
        
        if c_y>64 then
            local progress=min(c_y,c_y_target)/max(c_y,c_y_target)
            for i=1,6 do
                local setting=settings_options[i]
                local s=(i<5 and 119 or 53)+i*16
                --spr(s,124+i*14*progress,162-76*progress)
                local picked=i==selected[menu_lvl]
                local w=picked and 16 or 8
                sspr(setting[1],setting[2],8,8,i*14*progress+(i>selected[menu_lvl] and 8 or 0)-28,276-76*progress,w,w)
                if picked then
                    if (i!=1) spr(setting[5] and 176 or 177,#setting[3]*4-11,220)
                    print(setting[3].."\n\f5\|j"..(i>4 and acc_lock and "\#d\f6eNABLE COMBAT\nACCESSIBILITY.\n\|j\#7\f5" or "")..setting[4],-15,275-52*progress,14)
                end
            end
        end

        camera(expand_page_y*1.5,0)
        rectfill(87,-1,128,20,7)
        rect(88,-1,128,19,6)
        rectfill(87,6,89,15,7)
        line(98,19,126,19,7)
        print(menu_txt[menu_lvl],95,2)
        print("⬆️\n⬇️",85,5,9)

        camera()

        --print(confirm,0,0,0)
        --?c_y

    elseif stats then
        cls(8)
        camera(0,sheet_y-128)
        rectfill(0,0,64,128,0)
        rect(0,0,64,128,7)
        print("\#7mission\ncomplete\n",4,4,8)
        print("s\|fCORE\n \^t\^w"..get_score().."\n\n\^-t\^-wBEST\nCOMBO \^t\^w\|b"..p_combo.."X")
        if (sheet_y>=127) draw_adv_btn(54,118)
    else
        cls(12)
        local cx,cy=c_x-59+(p_x-c_x)*0.4,c_y-64+(p_y-c_y)*0.4
        if (not cam_enabled and p_spawned and not outro) cx,cy=0,-4
        shake(cx,cy)

        local wb_x=wbanner_cntr*3-135

        rectfill(0,00,127,127,7)
        map(0,0,0,0,16,15)

        shadow = 0.8

        for p in all(particles) do
            p:draw()
        end
        
        for h in all(hearts) do
            if pcollide(h[1],h[2],5,5) then
                if (p_health<3) p_health+=1
                del(hearts, h)
            end

            spr(81,h[1],h[2])
            h[3]-=1
            if (h[3]<=0) del(hearts, h)
        end

        if heli and pickup then
            circfill(heli_x+14,heli_y+30,12,7)
            line(heli_x+14,heli_y+16,heli_x+14,heli_y+26,9)
            pset(heli_x+14,heli_y+20)
            draw_halo(heli_x+14,heli_y+33)
        end

        clip(6-cx,8-cy,118,114)
        if (heli) ovalfill(heli_x+6,heli_y+32,heli_x+22,heli_y+35,6)
        if (wbanner_cntr!=-1) line(wb_x-63,88,wb_x+13,88,6)
        clip()

        if lvl_id==1 and sb_current==8 then
            if (not tt_move1) draw_halo(25,64)
            if (not tt_move2) draw_halo(63,30)
            if (not tt_move3) draw_halo(102,64)
        end

        p_current_anim = anims[p_anim]
        p_current_frame = p_current_anim[1] + flr(anim_cnt*p_current_anim[3]-0.5) % p_current_anim[2]
        h_current_anim = anims[6]
        h_current_frame = h_current_anim[1] + flr(anim_cnt*h_current_anim[3]) % h_current_anim[2]

        --[[
        if intro and intro_phase>1 then
            replace_all_col(6)
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
        ]]

        if outro_cntr==-1 then
            if h_v>0.5 then
                h_h/=2
            elseif h_mag_v == 0 and not h_dropping then
                h_current_frame = 132
                h_h=0
            end
            
            h_hide = lvl_id==1 and sb_current<11
            local h_visible=not h_held and not h_hide

            replace_all_col(6)
            if p_dropping then
                p_current_frame = 16
            else
                spr(p_current_frame,p_x,p_y+8,1,shadow,p_flip,true)
            end

            --if (h_v<0.5 and not h_dropping) h_current_frame=132
            if (h_visible and intro_phase!=1 and not h_dropping) spr(h_current_frame,h_x,h_y+8+h_h,1,shadow,h_flip,true)

            for e in all(es) do
                e:draw(true)
            end

            pal()

            if (h_visible) spr(h_current_frame,h_x,h_y-h_h,1,1,h_flip)
            if (not intro or intro_phase>=3) spr(p_current_frame,p_x,p_y,1,1,p_flip)

            --spr(p_current_frame,p_x,p_y+8,1,shadow,p_flip,true)

            --spr(p_current_frame,p_x,p_y,1,1,p_flip)

            for e in all(es) do
                e:draw(false)
            end

            if h_v > 0.5 or h_mag_v > 0.5 then
                fillp(▒)
                if (shadow>0.4) line(h_prev_x+3, h_prev_y+11, h_x+3, h_y+11, 6)
                line(h_prev_x+3, h_prev_y+3, h_x+3, h_y+3, 2)
                fillp()
            end
        elseif p_spawned then
            local h=2^(4.65-outro_cntr/8)
            line(heli_x+14,heli_y+15,heli_x+14,heli_y+3+h,9)
            spr(1,heli_x+9,heli_y+3+h)
        end

        if heli then
            local flag=global_cnt%2==0
            sspr(0,72,24,16,heli_x,heli_y)
            if (flag) ovalfill(heli_x+6,heli_y-1,heli_x+24,heli_y+5, 7)
            oval(heli_x+6,heli_y-1,heli_x+24,heli_y+5,flag and 13 or 6)
            flag=global_cnt%4<2
            line(heli_x+11,heli_y+(flag and 0 or 4),heli_x+19,heli_y+(flag and 4 or 0),6)
        end

        if not intro then
            sspr(24,72,16,16,wb_x,50)
            for i=1,15 do
                clip(wb_x-59-cx,51+i-cy,52,1)
                print("\#3\^t\^wwave \-c"..wave+1,wb_x-50-i/2,54,7)
                clip()
            end
            line(wb_x-8,54,wb_x,59,14)
            line(wb_x-13,64)
        end

        map(0,15,0,120,16,2) --top bar ui

        camera()
        map(16,0,0,0,16,2)
        
        --[[
        if wbanner_cntr!=-1 then
            local x=sqrt(4096-(2.14*wbanner_cntr-64)^2)
            if (wbanner_cntr>30) x=128-x
            rectfill(x-21,53,x+22,66,0)
            print("\^t\^wwave\-k"..tostr(wave+1),x-20,54,7)
        end
        ]]

        if pfp_cntr !=-1 then
            if sb_mode==1 then
                a = oval_anim[not trans and flr(pfp_cntr/2 + 2) or 1]

                ovalfill(pfp_x+a[1], pfp_y+a[2], pfp_x+a[3], pfp_y+a[4], 6)
                ovalfill(pfp_x+a[1]+1, pfp_y+a[2]+1, pfp_x+a[3]-1, pfp_y+a[4]-1, 14)

                if pfp_cntr==6 then
                    for i=1,29 do
                        pset(pfp_x+i, pfp_y+pfp_w/2+sin((i-global_cnt)/10)*3, 13)
                        pset(pfp_x+i, pfp_y+pfp_w/2+cos((i+global_cnt)/8)*4, 13)
                    end
                    sspr(88,0,32,32,pfp_x,pfp_y)
                end
            end

            if sb_cntr!=-1 then
                speech_bubble(39,22,d[lvl_id][sb_current],13)
            end
        end
        
        shake(0,0)
        sspr(0,32,24,8,3,1)
        if (p_health<=2) spr(69,19,1) --can probably make this more token efficient using sspr?
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

        if e_killed_cnt != e_wave_cnt or wbanner_cntr!=-1 then
            print("PROGRESS",95,0,13)
            rectfill(95,6,95+30*(e_killed_cnt/e_wave_cnt),8,14)
            line(95,6,95,8,0)
            line(125,6,125,8,0)
        elseif wave==wave_cnt then
            print("evacuate",95,2,global_cnt%30==0 and 8 or 14)
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
    
    --print(e_wave_quota[1].." "..e_wave_quota[2].." "..e_wave_quota[3],1,50)
    --print("\#0"..flr(stat(1)*100).."% cpu\n"..flr(stat(0)/20.48).."% mem", 1,116,7)
    --print(c_y,1,116,0)
    print("\#0"..pfp_cntr.."\n"..sb_auto_cntr.."\n"..sb_current.."\n"..sb_mode.."\n"..wbanner_cntr.."\n"..drawer_x[1],1,1,7)
    --if (p_spawned)print("\#0"..p_x.." "..p_y,1,1,7)
    --if (p_spawned)print("\#0\n\n"..e_alive_cnt.."\n"..e_conc_limit,1,1,7)
    --print("\#0"..c_x_target.." <- "..c_x.."\n"..c_y_target.." <- "..c_y,1,1,7)
    --if (p_spawned and #es!=0) print("\#0\n\n"..tostr(tt_roll).."\n"..roll_check_cntr,1,1,7)
end

function speech_bubble(x,y,text,c)
    if sb_mode==1 then
        map(16,2,x,y,10,4)

        if sb_cntr>=#text then
            sb_cntr=#text
            if (not p_spawned) draw_adv_btn(x+70,y+21)
        end

        print(sub(text, 1, sb_cntr), x+11, y+3,sb_mode==1 and 13 or 0)
    elseif sb_mode==2 then
        rectfill(0,113,128,128,5)
        sspr(checkm_cntr>0 and 0 or 8,88,8,8,2,116)
        print(text,11,115,15)
    end
end

function draw_adv_btn(x,y)
    spr(123 + global_cnt\10%2, x, y)
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

function generate_dwash(cx,cy)
    for i=1,3 do
        if dwash_cnt != 200 then
            add(particles, {
                x=cx-10+rnd(20),
                y=cy-10+rnd(20),
                draw=function(self)
                    local ow1,ow2=self.x,self.y
            
                    local d=sqrt((cx-ow1)^2 + (cy-ow2)^2)
                    if d>80 or not within_bounds(ow1-3,ow2) then
                        del(particles,self)
                    else
                        local a=atan2(cx-ow1, cy-ow2)
                        self.x-=cos(a)*50/d
                        self.y-=sin(a)*50/d
                        local w1,w2=self.x,self.y
                        if (within_bounds(w1,w2))line(ow1,ow2,w1,w2,6)
                    end
                end
            })
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

--[[
function draw_hanger_sign(x1,y1,x2,y2)
    circfill((x2+x1)/2,y1-4,1,6)
    local a=(x2-x1)*0.15
    line(x1+a,y1,(x2+x1)/2,y1-4,8)
    line(x2-a,y1,(x2+x1)/2,y1-4)
    rectfill(x1,y1,x2,y2,9)
end
--]]

function draw_drawer(dx,dy,_sel,pages)
    rectfill(-17,dy+54,46,dy+110,0) --top gap

    for rail_x=-2,(dx\8)+2 do --background rail
        spr(73,rail_x*8,dy+90)
    end

    temp = rnd(0x8000) --save rand seed to restore later

    local title=levels[selected[menu_lvl]][1]

    if pages then
        for lx=1,#levels do --pages
            local sel=lx==_sel
            local ready=dx>58+9.4*(#levels-lx)
            local x,y=dx+(lx-1-#levels)*12-49,dy+60-((sel and ready) and page_y+sin(global_cnt/70)*5 or 0)
            local _x=x+35

            if not (page_detail and lx==selected[menu_lvl]) then
                draw_page(x,y,x+30,y+45,false,lx,sel)

                if sel and menu_lvl==1 then
                    print("\#f\f9SELECT ❎",x+35,dy+33)
                    print((lx!=1 and "\f9⬅️\-h" or "")..title..(lx!=#levels and "\f9\-h➡️" or ""),_x,42,dy+9)
                end

                srand(lx)
                for ry=0,10 do
                    local _y=10+y+ry*2
                    line(x+2,_y,x+2+rnd(24),_y,6)
                end
            else
                draw_expanded_page(x,title)
            end
        end
    else
        for lx=1,2 do --pages
            local sel=lx==_sel 
            local ready=dx>48+9.4*(2-lx)
            local x,y=dx+(lx-3)*12-49,dy+60-((sel and ready) and page_y+sin(global_cnt/70)*5 or 0)
            local _x=x+35
            local title=lx==1 and "\f1rEGULAR ENDLESS" or "\f1mAGNET ENDLESS"

            if not (page_detail and lx==selected[menu_lvl]) then
                draw_page(x,y,x+30,y+45,true,"e"..lx,true)

                if sel and menu_lvl==2 then
                    print("\#f\f9SELECT ❎",x+35,dy+33)
                    print("\#7"..(lx!=1 and "\f9⬅️\-h" or "")..title..(lx!=2 and "\f9\-h➡️" or ""),_x,104,dy+9)
                end

                srand(lx)
                for ry=0,10 do
                    local _y=10+y+ry*2
                    line(x+2,_y,x+2+rnd(24),_y,6)
                end
            else
                draw_expanded_page(x-10,title)
            end
        end
    end

    srand(temp)

    for rail_x=-2,(dx\8)+2 do --foreground rail
        spr(72,rail_x*8,dy+96)
    end

    rectfill(-16,dy+106,dx,dy+108,4) --floor

    rectfill(dx-20,dy+54,dx+46,dy+110,1) --top outline
    rectfill(dx-16,dy+55,dx+45,dy+109,13) --door
    print("\#7OPERATION \n\fcicebreaker",dx-4,dy+65,9)
    spr(76,dx+11,dy+60) --tape
    sspr(80,32,16,8,dx,dy+80,32,16) --handle

    line(-17,dy+54,-17,dy+110,0) -- depth blocker (black line on left)
end

function draw_page(x1,y1,x2,y2,alt,t,sel)
    rectfill(x1,y1,x2,y2,7)
    rect(x1,y1,x2,y2,alt and 12 or 6)
    print(t,x1+2,y1+2,sel and 1 or 13)
end

function draw_expanded_page(x,title)
    expand_page_x=x
    draw_page(expand_page_x,expand_page_y,expand_page_x+75,expand_page_y+105,menu_lvl==2,"",false)
    print(title, expand_page_x+3, expand_page_y+3)
    line(expand_page_x+3, expand_page_y+9,expand_page_x+4*#title-1,expand_page_y+9,6)
    local txt=menu_lvl==1 and levels[selected[menu_lvl]][2] or "cHALLENGE\nYOURSELF IN AN\nENDLESS ONSLAUGHT!\n\n\f2hOW LONG CAN YOU\nSURVIVE?"
    print(txt,expand_page_x+3, expand_page_y+12, 13)
    line(expand_page_x+4,expand_page_y+95,expand_page_x+69,expand_page_y+95)
    print("SIGNATURE  \f9HOLD❎", expand_page_x+4, expand_page_y+97, 6)
    print("RETURN🅾️", expand_page_x+78, expand_page_y+52, 8)
    sspr(40,16,32,16,expand_page_x+5,expand_page_y+80,64,16)
    rectfill(expand_page_x+4+69*confirm/30,expand_page_y+80,expand_page_x+69,expand_page_y+94,7)
    if (stamp_cntr>=10) sspr(96,64,32,32,expand_page_x+35,expand_page_y+60)
end