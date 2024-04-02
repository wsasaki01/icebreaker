function create_e()
    repeat
        local p=rnd(1)
        t=p<0.1 and 3 or p<0.2 and 2 or 1
    until e_wave_quota[t]!=0
    e_wave_quota[t]-=1

    local _x,_y=3+rnd(114),2+rnd(113)

    add(es, setmetatable({
        x=_x, y=_y,
        type=t,
        speed=t==2 and 1.2 or 0.6,
        spawn_cnt=18, anim_cnt=0, del_cnt=0,
        s=t==3 and 240 or 192,
        proj_cnt=t==3 and 0 or -1, dir=rnd(1)>0.5 and -1 or 1,
        a=atan2(p_x-_x, p_y-_y),
        heal=t==1 and rnd(1)<0.05,

        move = function(self)
            if self.del_cnt!=0 then
                self.del_cnt+=1
                if self.del_cnt==3 then
                    e_alive_cnt-=1
                    if (heal) add(hearts, {self.x,self.y,150})
                    del(es,self)
                end
            else
                if self.type==3 then
                    if (self.anim_cnt==89) add(proj_buffer,{self.x,self.y}) 
                elseif self.spawn_cnt==0 then
                    local start_a=abs(self.a)
                    local target_a=atan2(p_x-self.x, p_y-self.y)
                    local step=0.027

                    if abs(start_a - target_a) > 0.5 then
                        if start_a < target_a then
                            start_a += 1
                        else
                            start_a -= 1
                        end
                    end

                    new_angle = start_a + min(step, abs(target_a - start_a))*(target_a-start_a<0 and -1 or 1)
                    new_angle %= 1

                    self.a=new_angle

                    self.x+=cos(self.a)*self.speed
                    self.y+=sin(self.a)*self.speed

                    self.a %=1
                end

                if self.spawn_cnt!=0 then
                    self.spawn_cnt -= 1
                    if (self.spawn_cnt%2==0) self.s+=1
                elseif self.type==3 then
                    self.s=(self.anim_cnt>80 and self.anim_cnt<89) and 251 or 249
                end

                self.anim_cnt+=1
                self.anim_cnt%=270

                if (self.type!=3) self.dir=p_x<self.x and 1 or -1
            end
        end,

        check_hammer_collision = function(self)
            if self.del_cnt==0 and self.spawn_cnt == 0 and 
            collide(h_x, h_y, h_xw, h_yw, self.x, self. y,8,8) and
            (h_type==1 and h_v > 0.5 or h_type==2 and h_mag_v>1) then
                increase_score(10)
                e_killed_cnt+=1
                big_combo_print=2
                continue=3
                sh_str+=0.05+(self.speed*0.1)
                self.del_cnt=1
            end
        end,

        check_player_collision = function(self)
            if self.type!=3 and self.del_cnt==0 and self.spawn_cnt==0 and p_inv_cntr==-1 and pcollide(self.x+3,self.y+3,2,2) then
                p_inv_cntr=45
                p_health-=1
                p_combo=0
                continue=12
                sh_str+=1
            end
        end,

        draw = function(_ENV, sh)
            if sh then
                spr(s,x,y+(type==3 and 3 or 8),1,shadow,dir>0,true)
            else
                spr(del_cnt==0 and s or (type==3 and 250 or 202),x,y,1,1,dir>0)

                if s==201 then
                    if type==2 then
                        spr(anim_cnt/27>7 and 209 or 210,x,y,1,1,dir>0)
                    else
                        if (heal) spr(211,x,y)
                        if (not heal) spr(del_cnt!=0 and 224 or 208,x,y,1,1,dir>0,p_y>y)
                    end
                end
            end
        end
    }, {__index=_ENV}))

    e_alive_cnt+=1
end

function create_proj(ix,iy,idir)
    add(es, setmetatable({
        x=ix,y=iy,dir=idir,trace=true,anim_cnt=0,s=is_in(idir,{0.5,0}) and 203 or 205,del_cnt=0,

        move = function(self)
            if self.del_cnt!=0 then
                self.s=207
                self.del_cnt+=1
                if (self.del_cnt==3) e_alive_cnt-=1 del(es,self)
            else
                self.x+=cos(self.dir)*1.2
                self.y+=sin(self.dir)*1.2
                self.anim_cnt+=1
                self.anim_cnt%=270
                if (not within_bounds(self.x,self.y)) self.del_cnt=1
            end
        end,

        check_hammer_collision = function(self)
            return
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

        draw = function(_ENV, sh)
            if sh then
                spr(s,x,y+1,1,1,dir==0.5,dir==0.75)
            else
                local o=0
                if (del_cnt==0 and anim_cnt%2==1) o=1
                spr(s+o,x,y,1,1,dir==0.5,dir==0.75)
            end
        end
    }, {__index=_ENV}))

    e_alive_cnt+=1
end