function log(args)
    for i in all(args) do
        print(i, 0)
    end
end

function score()
    local score = tostr(flr(p.score))
    local pos = 32
    local count = 0
    for char in all(score) do
        count += 1
        local digit = tonum(char)
        spr(64+digit, pos+7*count, 3)
    end

    if p.multi != 1 then
        spr(75, 33, 15)
        local multi = tostr(p.multi)
        local pos = 32
        local count = 0
        for char in all(multi) do
            count += 1
            if char != "." then
                local digit = tonum(char)
                spr(64+digit, pos+7*count, 15)
            else
                spr(74, pos+7*count, 15)
                pos -= 4
            end
        end

        if multi % 1 == 0 then
            count+=1
            spr(74, pos+7*count, 15)
            pos-=4
            count+=1
            spr(64, pos+7*count, 15)
        end
    end

    if p.combo_cnt != 0 then
        rect(33, 24, 33+p.combo_cnt, 24, 8)
        rect(33, 25, 33+p.combo_cnt, 25, 14)
    end
end

function create_hit_sign(x, y, num)
    add(hit_signs, {
        x = x, y = y,
        num = num,
        cnt = 30,

        draw = function(self)
            rectfill(self.x-1, self.y-4, self.x+1, self.y+1, 7)
            rectfill(self.x-11, self.y-10, self.x+16, self.y-4, 7)
            line(self.x, self.y, self.x, self.y-4, 14)
            print(tostr(self.num).."X HIT!", self.x-10, self.y-9)
        end,

        decay = function(self)
            self.cnt-=1
            if self.cnt==0 then
                del(hit_signs, self)
            end
        end
    })
end