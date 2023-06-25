function create_weapon(type, mod)
    local side=8
    local launch_v=10
    local v_decay=0.8
    local magnet_v_decay=0.9
    local throw_tax=0

    if (mod==1) then
        side=16
        launch_v=6
        v_decay=0.8
        magnet_v_decay=0.88
        throw_tax=2
    elseif (mod==2) then
        side=4
        launch_v=20
        v_decay=0.82
        magnet_v_decay=0.9
    end
    return setmetatable({
        type=type,
        s=3,

        x=100, xw=side,
        y=100, yw=side,

        equipped=false,
        thrown=false,
        hit_cnt=0, last_hit={x=0, y=0},

        d=0, d_history={},
        path={x=0, y=0},

        launch_v=launch_v, v=0, magnet_v=0.5,
        v_decay=0.8, magnet_v_decay=0.9,
        throw_tax=throw_tax,

        draw = function(_ENV)
            if not equipped then
                sspr(24, 0, 8, 8, x, y, xw, yw)
            end
        end,

        throw = function(_ENV)
            thrown = true
            equipped = false
            p.force.v = throw_tax
            p.force.dir = atan2(-diff.x, -diff.y)
            v = launch_v
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
                v *= 0.75*v_decay
            elseif destx <= 0 then
                x = 0
                path.x *= -1
                v *= 0.75*v_decay
            else
                x = destx
            end

            if desty>=120 then
                y = 120
                path.y *= -1
                v *= 0.75*v_decay
            elseif desty <= 0 then
                y = 0
                path.y *= -1
                v *= 0.75*v_decay
            else
                y = desty
            end

            v*=v_decay
        end,

        move_magnet = function(_ENV)
            if magnet_v > _g.h_magnet_v_min then
                local mag_d = atan2(p.x-x, p.y-y)
                add(d_history, mag_d)
                if #d_history>3 then
                    del(d_history, d_history[1])
                end
                x+=cos(mag_d)*magnet_v
                y+=sin(mag_d)*magnet_v

                magnet_v *= magnet_v_decay
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
                local old_magnet_v = magnet_v
                magnet_v = _g.h_magnet_v_min
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                end
                hit_cnt = 0

                if coll then
                    equipped = true
                    p.force.v = old_magnet_v*0.5
                    p.force.dir = d_history[2]
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