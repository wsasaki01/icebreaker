function create_e()
    add(es, setmetatable({
        x=rnd(120), y=rnd(120),
        --speed=0.8,
        speed=0.8+rnd(0.5),
        spawn_cnt = 36, anim_cnt=0, del_cnt=0,
        s = 192,

        move = function(self)
            if self.del_cnt!=0 then
                self.del_cnt+=1
                if (self.del_cnt==3) del(es,self)
            elseif self.spawn_cnt == 0 then
                local a=atan2(p_x-self.x, p_y-self.y)
                self.x+=cos(a)*self.speed
                self.y+=sin(a)*self.speed
            end
        end,

        check_hammer_collision = function(self)
            if self.del_cnt==0 and self.spawn_cnt == 0 and 
            collide(h_x, h_y, h_xw, h_yw, self.x, self. y,8,8) and
            h_v > 0.5 then
                if (tutorial and sb_current==7) next_text()
                increase_score(10)
                e_killed_cnt+=1
                big_combo_print=2
                continue=3
                sh_str+=0.05+(self.speed*0.1)
                self.del_cnt=1
            end
        end,

        check_player_collision = function(self)
            if self.del_cnt==0 and p_inv_cntr==-1 and pcollide(self.x+3,self.y+3,2,2) then
                p_inv_cntr=45
                p_health-=1
                p_combo=0
                continue=12
                sh_str+=1
            end
        end,

        draw = function(_ENV, reflection)
            if spawn_cnt!=0 then
                spawn_cnt -= 1
                if (spawn_cnt%4==0) s+=1
            end

            anim_cnt+=1
            anim_cnt%=10

            if reflection then
                spr(s,x,y+8,1,shadow,false,true)
            else
                if (s==201) pal(1,12)
                spr(del_cnt==0 and s or 202,x,y)
                pal()

                if s==201 then
                    if speed>=1.1 then
                        spr(anim_cnt>7 and 209 or 210,x,y,1,1,p_x<x)
                    else
                        spr(del_cnt!=0 and 224 or 208,x,y,1,1,p_x<x,p_y>y)
                    end
                end
            end

            print(del_cnt,0)
        end
    }, {__index=_ENV}))
end