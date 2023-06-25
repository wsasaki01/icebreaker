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
        gap_list={},

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
            if v>1 then
                gap_list={}
                d = atan2(path.x, path.y)

                local destx = x+cos(d)*v
                local desty = y+sin(d)*v

                local x_path = {}
                local y_path = {}

                if destx >= 128-xw then
                    destx = 128-xw
                    path.x *= -1
                    v *= 0.75*v_decay
                elseif destx <= 0 then
                    destx = 0
                    path.x *= -1
                    v *= 0.75*v_decay
                end

                distx = x-destx

                if abs(distx) > xw then
                    for i=1, 4 do
                        x+=distx/4
                        add(x_path, x)
                    end
                    x=destx
                else
                    x=destx
                    for i=1, 4 do
                        add(x_path, x-distx/2)
                    end
                end

                if desty>=120 then
                    desty = 120
                    path.y *= -1
                    v *= 0.75*v_decay
                elseif desty <= 0 then
                    desty = 0
                    path.y *= -1
                    v *= 0.75*v_decay
                end
                
                disty = y-desty
                
                if abs(disty) > yw then
                    for i=1, 4 do
                        y+= disty/4
                        add(y_path, y)
                    end
                    y=desty
                else
                    y=desty
                    for i=1, 4 do
                        add(y_path, y-disty/2)
                    end
                end

                v*=v_decay
                for i=1, 4 do
                    add(gap_list, {x=x_path[i], y=y_path[i]})
                end
            end
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