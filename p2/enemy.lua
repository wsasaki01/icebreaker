function create_enemy()
    add(enemies, {
        x = flr(rnd(128)), xw = 8,
        y = flr(rnd(128)), yw = 8,
        speed = e_s_min + rnd(e_s_max-e_s_min),
        s = 7,
        spawn = 30,

        move = function(self)
            local a = atan2(p.x-self.x, p.y-self.y)
            self.x+=cos(a)*self.speed
            self.y+=sin(a)*self.speed
        end,

        draw = function(self)
            spr(self.s, self.x, self.y)
        end,

        die = function(self)
            for a in all(attacks) do
                if collide(self.x, self.y, self.yw, self.xw, a.x, a.y, a.xw, a.yw) then
                    p.score+=flr(100*self.speed/(e_s_min+e_range))
                    p.multi+=0.1
                    p.multi=ceil(p.multi*10)/10
                    p.combo_cnt=p.combo_fr
                    sh_str1+=0.1
                    sh_str2+=0.09
                    hitstop = true
                    sfx(0)
                    del(enemies, self)
                end
            end
        end
    })
end