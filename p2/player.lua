function create_player()
    return {
        s = 1, temp_s = 0, -- sprite
        x = 50, xw = 8,
        y = 50, yw = 8,
        score = 0, multi = 1, combo_rec = 0,
        health = 3, max_health = 3,

        combo_cnt = 0,
        combo_fr = 60,

        -- inv
        flash = false,
        i = false,
        i_cnt = 0,
        i_fr = false,

        d = 0,

        -- damaged frame effect
        hit = false,
        hit_count = 0,
        hit_frames = 4,

        a_cooldown = 1*30,
        a_charge = true,

        rolling = false,
        roll_cnt = 0,
        roll_fr = 10,

        move = function(self)
            -- normal movement
            local diff = {x=0,y=0}
            local step = h.equipped and 0.85 or 1

            if btn(1) and self.x<120 then
                self.x+=step
                diff.x+=1
            end

            if btn(0) and self.x>0 then
                self.x-=step
                diff.x-=1
            end

            if btn(2) and self.y>0 then
                self.y-=step
                diff.y-=1
            end

            if btn(3) and self.y<120 then
                self.y+=step
                diff.y+=1
            end

            return diff
        end,

        sprite = function(self)
            self.s = h.equipped and 4 or 1
        end,

        draw = function(self)
            if not self.i then
                spr(self.s, self.x, self.y)
            elseif self.flash then
                if not self.i_fr then
                    spr(self.s, self.x, self.y)
                    self.i_fr = true
                else
                    self.i_fr = false
                end
            else
                spr(self.temp_s, self.x, self.y)
            end
        end,

        die = function(self)
            for e in all(enemies) do
                if e.spawn_cnt == 0 and not self.i and collide(self.x+1, self.y+1, self.yw-2, self.xw-2, e.x+1, e.y+1, e.xw-2, e.yw-2) then
                    self.health -= 1

                    self.combo_cnt = 0

                    self.i = true
                    self.i_cnt = 30
                    self.flash = true
                    self.temp_s = 5
                end
            end

            if self.health == 0 then
                play = false
                retry = true
                if p.score > h_score then
                    h_score = p.score
                    dset(0, p.score)
                end
            end
        end,

        cooldown = function(self)
            if (self.a_charge == true) or self.a_charge == self.a_cooldown then
                self.a_charge = true
            else
                self.a_charge += 1
            end
        end,

        inv = function(self)
            if self.i_cnt != 0 then
                self.i_cnt-=1
            else
                self.i = false
                self.flash = false
            end
        end,

        roll = function(self)
            self.x += cos(self.d)*3
            self.y += sin(self.d)*3
            if self.x < 0 then
                self.x = 0
            end

            if self.x > 120 then
                self.x = 120
            end
            if self.y < 0 then
                self.y = 0
            end

            if self.y > 120 then
                self.y = 120
            end
            self.roll_cnt += 1
            self.temp_s = 8
            if self.roll_cnt == self.roll_fr then
                self.rolling = false
                self.roll_cnt = 0
            end
        end,

        combo = function(self)
            if self.combo_cnt != 0 then
                self.combo_cnt-=1
            else
                if (self.multi-1)*10 > self.combo_rec then
                    self.combo_rec = (self.multi-1)*10
                end

                if self.combo_rec > h_combo then
                    h_combo = self.combo_rec
                    dset(1, self.combo_rec)
                end
                self.multi=1
            end
        end
    }
end