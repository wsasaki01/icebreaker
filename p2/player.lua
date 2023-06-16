function create_player()
    return {
        s = 1, temp_s = 0,
        x = 50, xw = 8,
        y = 50, yw = 8,
        score = 0, multi = 1, combo_record = 0,
        health = 3,

        combo_count = 0,
        combo_frames = 60,

        flash = false,
        i = false,
        i_count = 0,
        i_frame = false,

        d = 0,

        hit = false,
        hit_count = 0,
        hit_frames = 4,

        cooldown = 1*30,
        charge = true,

        rolling = false,
        roll_count = 0,
        roll_frames = 10,

        sprite = function(self)
            self.s = h.equipped and 4 or 1
        end,

        draw = function(self)
            if not self.i then
                spr(self.s, self.x, self.y)
            elseif self.flash then
                if not self.i_frame then
                    spr(self.s, self.x, self.y)
                    self.i_frame = true
                else
                    self.i_frame = false
                end
            else
                spr(self.temp_s, self.x, self.y)
            end
        end,

        die = function(self)
            for e in all(enemies) do
                if e.spawn == 0 and not self.i and collide(self.x+1, self.y+1, self.yw-2, self.xw-2, e.x+1, e.y+1, e.xw-2, e.yw-2) then
                    self.health -= 1

                    self.hit = true
                    self.hit_count = self.hit_frames

                    self.combo_count = 0

                    self.i = true
                    self.i_count = 30
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

        invincibilty = function(self)
            if self.i_count != 0 then
                self.i_count-=1
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
            self.roll_count += 1
            self.temp_s = 8
            if self.roll_count == self.roll_frames then
                self.rolling = false
                self.roll_count = 0
            end
        end,

        combo = function(self)
            if self.combo_count != 0 then
                self.combo_count-=1
            else
                if (self.multi-1)*10 > self.combo_record then
                    self.combo_record = (self.multi-1)*10
                end

                if self.combo_record > h_combo then
                    h_combo = self.combo_record
                    dset(1, self.combo_record)
                end
                self.multi=1
            end
        end
    }
end