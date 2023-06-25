function create_weapon(type)
    return setmetatable({
        type = type,
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
            move_normal(_ENV)
            if (type==2) move_magnet(_ENV)
        end,

        move_normal = function(_ENV)
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
        end,

        move_magnet = function(_ENV)
            if magnet_v > _g.h_magnet_v_min then
                local mag_d = atan2(p.x-x, p.y-y)
                x+=cos(mag_d)*magnet_v
                y+=sin(mag_d)*magnet_v

                magnet_v *= 0.9
                if magnet_v < _g.h_magnet_v_min then
                    magnet_v = _g.h_magnet_v_min
                end
            end
        end,

        check = function(_ENV)
            if (v <= 1) v = 0

            local coll = collide(
                p.x, p.y, p.xw, p.yw,
                x, y, xw, yw
            )

            if (type==1) check_normal(_ENV, coll)
            if (type==2) check_magnet(_ENV, coll)
        end,

        check_normal = function(_ENV, coll)
            if v <= _g.h_v_min or (coll and v<1) then
                thrown = false
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end
                hit_cnt = 0

                if coll then
                    equipped = true
                    p.s = 4
                    _g.throw_stick = true
                    sfx(1)
                end
            else
                thrown = true
            end
        end,

        check_magnet = function(_ENV, coll)
            if (v <= _g.h_v_min and magnet_v <= _g.h_magnet_v_min) or (coll and v<1) then
                thrown = false
                magnet_v = _g.h_magnet_v_min
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end
                hit_cnt = 0

                if coll then
                    equipped = true
                    p.s = 4
                    _g.throw_stick = true
                    sfx(1)
                end
            elseif (v+magnet_v)/2 > 1 then
                thrown = true
            end
        end

    }, {__index = _ENV})
end