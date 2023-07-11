function create_weapon(type, mod)
    local side=8
    local launch_v=10
    local v_decay=0.8
    local magnet_v_decay=0.9
    local throw_tax=0
    local reverse=false
    local s=128

    if type==2 then
        s=129
    elseif type==3 then
        s=130
    end

    if mod==2 then -- giant
        side=16
        launch_v=6
        v_decay=0.8
        magnet_v_decay=0.88
    elseif mod==3 then -- tiny
        side=4
        s+=16
        launch_v=20
        v_decay=0.82
        throw_tax=4.5
    elseif mod==4 then -- reverse
        reverse=true
    end
    return setmetatable({
        type=type, mod=mod,
        s=s,

        x=100, xw=side,
        y=100, yw=side,

        equipped=false,
        thrown=false,
        hit_cnt=0, last_hit={x=0, y=0},

        d=0, d_history={},
        path={x=0, y=0},
        reverse=reverse,
        attack_gap_list={},
        catch_gap_list={},

        launch_v=launch_v, v=0, magnet_v=0.5,
        v_decay=0.8, magnet_v_decay=magnet_v_decay,
        throw_tax=throw_tax,
        attacking=false,

        draw = function(_ENV)
            if (equipped or hub or config) return

            if mod==2 then
                sspr(s%16*8, s\16*8, 8, 8, x, y, xw, yw)
            else
                spr(s, x, y)
            end
        end,

        throw = function(_ENV)
            thrown = true
            equipped = false
            p.force.v = throw_tax
            p.force.dir = atan2(-diff.x * (reverse and -1 or 1), -diff.y * (reverse and 1 or 1))
            v = launch_v
            path.x = diff.x*(reverse and -1 or 1)
            path.y = diff.y*(reverse and -1 or 1)
            hit_cnt = 0
            if mod==2 then
                sfx(9)
            elseif mod==3 then
                sfx(11)
            else
                sfx(2)
            end
        end,

        move = function(_ENV)
            if (hub or config) return

            attack_gap_list={}
            catch_gap_list={}
            move_normal(_ENV)
            if (type==2) move_magnet(_ENV)
        end,

        move_normal = function(_ENV)
            if v>1 then
                d = atan2(path.x, path.y)

                local destx = x+cos(d)*v
                local desty = y+sin(d)*v

                local x_path = {}
                local y_path = {}

                if destx >= bounds[2].x-xw then
                    destx = bounds[2].x-xw
                    path.x *= -1
                    v *= 0.75*v_decay
                elseif destx <= bounds[1].x then
                    destx = bounds[1].x
                    path.x *= -1
                    v *= 0.75*v_decay
                end

                local distx = destx-x

                for i=1, 5 do
                    x+=distx/5
                    add(x_path, x)
                end
                x=destx
                
                if desty>=bounds[2].y-yw then
                    desty = bounds[2].y-yw
                    path.y *= -1
                    v *= 0.75*v_decay
                elseif desty <= bounds[1].y then
                    desty = bounds[1].y
                    path.y *= -1
                    v *= 0.75*v_decay
                end
                
                local disty = desty-y
                
                for i=1, 5 do
                    y+=disty/5
                    add(y_path, y)
                end
                y=desty

                v*=v_decay
                for i=1, 5 do
                    add(attack_gap_list, {x=x_path[i], y=y_path[i]})
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

                local x_path = {}
                local y_path = {}

                local destx = x+cos(mag_d)*magnet_v
                local desty = y+sin(mag_d)*magnet_v

                local distx = x-destx
                local disty = y-desty

                for i=1, 5 do
                    x+=distx/5
                    add(x_path, x)
                end
                x=destx

                for i=1, 5 do
                    y+=disty/5
                    add(y_path, y)
                end
                y=desty

                magnet_v *= magnet_v_decay
                if magnet_v < _g.h_magnet_v_min then
                    magnet_v = _g.h_magnet_v_min
                end

                for i=1, 5 do
                    add(catch_gap_list, {x=x_path[i], y=y_path[i]})
                end
            end
        end,

        check = function(_ENV)
            if (hub or config) return

            if (v <= 1) v = 0
            
            local flag = false
            
            if not (mod==2 and v!=0) then
                if collide(
                    p.x, p.y, p.xw, p.yw,
                    x, y, xw, yw
                ) then
                    flag = true
                    if (mod==2 and v!=0) flag=false
                end

                for loc in all(catch_gap_list) do
                    if collide(
                        loc.x, loc.y, xw, yw,
                        p.x, p.y, p.xw, p.yw
                    ) then
                        flag = true
                    end
                end
            end

            if (type==1 or type==3) check_normal(_ENV, flag)
            if (type==2) check_magnet(_ENV, flag)
        end,

        check_normal = function(_ENV, coll)
            if v <= _g.h_v_min or (coll and v<1) then
                thrown = false
                
                if hit_cnt >= hit_sign_lim then
                    create_hit_sign(last_hit.x+4, last_hit.y+4, hit_cnt)
                    if (hit_cnt==cont.level[1]) p.w_wipeout=true
                end
                hit_cnt = 0

                if coll then
                    equipped = true
                    p.s = 4
                    _g.o_stick = true
                    if mod==3 then
                        sfx(10)
                    else
                        sfx(1)
                    end
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
                    _g.o_stick = true
                    if old_magnet_v > 2 then
                        sfx(7)
                    else
                        sfx(1)
                    end
                end
            elseif (v+magnet_v)/2 > 1 then
                thrown = true
            end
        end,

    }, {__index = _ENV})
end