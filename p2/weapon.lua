function create_weapon()
    return setmetatable({
        s = 3,
        x = 100, xw = 8,
        y = 100, yw = 8,
        equipped = false,
        thrown = false, hit_cnt = 0, last_hit={x=0, y=0},
        d = 0,
        v = 0,
        path = {x=0, y=0},

        draw = function(_ENV)
            if not equipped then
                spr(s, x, y)
            end
        end,

        throw = function(_ENV)
            thrown = true
            equipped = false
            v = 10
            path = diff
            hit_cnt = 0
            sfx(2)
        end,

        move = function(_ENV)
            d = atan2(h.path.x, h.path.y)

            local destx = x+cos(h.d)*h.v
            local desty = y+sin(h.d)*h.v

            if destx >= 120 then
                x = 120
                path.x *= -1
                v *= 0.6
            elseif destx <= 0 then
                x = 0
                path.x *= -1
                v *= 0.6
            else
                x = destx
            end

            if desty>=120 then
                y = 120
                path.y *= -1
                v *= 0.6
            elseif desty <= 0 then
                y = 0
                path.y *= -1
                v *= 0.6
            else
                y = desty
            end

            v*=0.8
        end,

        check = function(_ENV)
            if v >= 1 then
                thrown = true
            else
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end

                thrown = false
                hit_cnt = 0
                v = 0

                if collide(
                    p.x, p.y, p.xw, p.yw,
                    x, y, xw, yw
                ) then
                    equipped = true
                    p.s = 4
                    sfx(1)
                end
            end
        end,
    }, {__index = _ENV})
end