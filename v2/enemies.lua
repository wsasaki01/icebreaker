function create_e()
    add(es, setmetatable({
        x=rnd(120), y=rnd(120),
        speed=0.8, spawn_cnt = 36,
        s = 208,

        move = function(_ENV)
            if spawn_cnt == 0 then
                local a=atan2(_g.p_x-x, _g.p_y-y)
                x+=cos(a)*speed
                y+=sin(a)*speed
            end
        end,

        check_collision = function(self)
            if self.spawn_cnt == 0 and 
            collide(h_x, h_y, h_xw, h_yw, self.x, self. y,8,8) and
            h_v > 0.5 then
                if (tutorial and t_sb_current==7) next_text()
                increase_score(10)
                e_killed_cnt+=1
                big_combo_print=2
                continue=3
                del(es, self)
            end
        end,

        draw = function(_ENV, reflection)
            if spawn_cnt!=0 then
                spawn_cnt -= 1
                if (spawn_cnt%4==0) s+=1
            end

            if reflection then
                spr(s,x,y+8,1,shadow,false,true)
            else
                if (s==217) pal(1,12)
                spr(s,x,y)
                pal()
            end
            
        end
    }, {__index=_ENV}))
end