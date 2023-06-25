function create_weapon()
    return setmetatable({
        s = 3,
        x = 100, xw = 8,
        y = 100, yw = 8,
        equipped = false,
        thrown = false, hit_cnt = 0, last_hit={x=0, y=0},
        d = 0,
        v = 0, magnet_v = 0.5,
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
            d = atan2(path.x, path.y)

            local destx = x+cos(d)*v
            local desty = y+sin(d)*v

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

            if magnet_v > 0.5 then
                local mag_d = atan2(p.x-x, p.y-y)
                x+=cos(mag_d)*magnet_v
                y+=sin(mag_d)*magnet_v

                magnet_v *= 0.9
                if magnet_v < 0.5 then
                    magnet_v = 0.5
                end
            end
        end,

        check = function(_ENV)
            if v < 1 and magnet_v <= 0.5 then
                thrown = false
                v = 0
                magnet_v = 0.5
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end

                hit_cnt = 0
            else
                thrown = true
            end

            if collide(
                p.x, p.y, p.xw, p.yw,
                x, y, xw, yw
            ) then
                equipped = true
                thrown = false
                v = 0
                magnet_v = 0.5
                p.s = 4
                throw_stick = true
                sfx(1)
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end

                hit_cnt = 0
            end
        end,
    }, {__index = _ENV})
end