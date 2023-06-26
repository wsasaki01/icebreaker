function log(args)
    for i in all(args) do
        print(i, 0)
    end
end

function score()
    local score = remove_zero(format_score(p.score1, p.score2, p.score3))
    print(score, 125-4*#score, 5, 3)

    if p.multi != p.base_multi then
        spr(75, 33, 3)
        local multi = tostr(p.multi)
        local pos = 32
        local cnt = 0
        for char in all(multi) do
            cnt += 1
            if char != "." then
                local digit = tonum(char)
                spr(64+digit, pos+7*cnt, 3)
            else
                spr(74, pos+7*cnt, 3)
                pos -= 4
            end
        end

        if multi % 1 == 0 then
            cnt+=1
            spr(74, pos+7*cnt, 3)
            pos-=4
            cnt+=1
            spr(64, pos+7*cnt, 3)
        end
    end

    if p.combo_cnt != 0 then
        rect(32, 13, 32+60*(p.combo_cnt/p.combo_fr), 14, 8)
        rect(32, 15, 32+60*(p.combo_cnt/p.combo_fr), 15, 14)
    end
end

function create_hit_sign(x, y, num)
    add(hit_signs, setmetatable({
        x = x, y = y,
        num = num,
        cnt = 30,

        draw = function(_ENV)
            rectfill(x-1, y-4, x+1, y+1, 7)
            rectfill(x-11, y-10, x+16, y-4, 7)
            line(x, y, x, y-4, 14)
            print(tostr(num).."X HIT!", x-10, y-9)
        end,

        decay = function(self)
            self.cnt-=1
            if self.cnt==0 then
                del(hit_signs, self)
            end
        end
    }, {__index=_ENV}))
end