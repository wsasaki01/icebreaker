function start_game()
    dset(4, menu_op.h_type)
    dset(5, menu_op.mod)

    p = create_player(menu_op.h_type, menu_op.mod)
    h = create_weapon(menu_op.h_type, menu_op.mod)
    cont = create_controller(get_lvl(1))

    particles={}
    float_scores={}

    attacks = {}
    enemies = {}
    hit_signs = {}
    hearts = {}

    sh_str1 = 0
    sh_str2 = 0
    sh_str3 = 0

    fr=0
end

function format_score(s1, s2, s3)
    local out = ""
    local scores = {s3, s2, s1}
    for score in all(scores) do
        for i=1, 4-#tostr(score) do
            out=out.."0"
        end
        out=out..tostr(score)
    end
    return out
end

function remove_zero(score)
    while score[1] == "0" do
        score = sub(score, 2)
    end
    if (score == "") score = "0"
    return score
end

function check_high_score(current, record)
    for i=1, 12 do
        if tonum(current[i]) < tonum(record[i]) then
            return false
        elseif tonum(current[i]) > tonum(record[i]) then
            return true
        end
    end
    return false
end

function rng(min, max)
    return min < p.kill_cnt and p.kill_cnt <= max
end

function round(num)
    if (num%1>=0.5) return ceil(num)
    if (num%1<0.5) return flr(num)
end

function random_select(ops)
    return ops[flr(rnd(#ops))+1]
end

function create_controller(level)
    return setmetatable({
        level=level,
        display_wave=1,
        wave=1, max_wave=#level,
        e_cnt=level[1][1],
        mobs=level[1][2],
        selection={},
        finished=false,
        start_wait=false,
        waiting=false,
        hit=false,
        totem_cnt=-1,
        path={7,8,8,8,8,8,8,3},

        check_totem=function(_ENV)
            if start_wait and h.equipped then
                waiting=true
                start_wait=false
            end
            if (not waiting) return

            if not hit and h.attacking and collide(
                h.x, h.y, h.xw, h.yw,
                70, 62, 8, 8
            ) then
                hit=true
                _g.sh_str1+=0.1
                _g.hs=3
                p.multi+=0.1
                totem_cnt=0
            end

            if totem_cnt>-1 then
                totem_cnt+=1
            end

            if not hit and totem_cnt>=4 then
                totem_cnt=4
            elseif hit and totem_cnt>#path then
                totem_cnt=-1
                hit=false
                waiting=false
                _g.hs=3
                _g.sh_str1+=0.1
                _g.sh_str2+=0.09
                _g.sh_str3+=0.09
                for i=1,flr(rnd(15))+5 do
                    create_particle(74, 66, 2)
                end
            end
        end,

        draw_totem=function(_ENV)
            if (totem_cnt<=-1) return

            if not hit then
                for i=1,totem_cnt do
                    print(display_wave, 73, 66-i, 12)
                end
                print(display_wave, 73, 65-totem_cnt, 2)
            else
                for i=1,path[totem_cnt] do
                    print(display_wave, 73, 66-i, 12)
                end
                print(display_wave, 73, 65-path[totem_cnt], 2)
            end
        end,

        check_wave=function(_ENV)
            if (#enemies>0) return

            local flag=true
            for item in all(mobs) do
                if (item!=0) flag=false
            end

            if flag and not start_wait and not waiting then
                start_wait=true
                totem_cnt=0
                display_wave+=1
                if wave!=max_wave then
                    wave+=1
                    e_cnt=level[wave][1]
                    mobs=level[wave][2]
                else
                    finished=true
                end
            end
        end,

        update_quota = function(_ENV)
            selection={}
            for i=1, #mobs do
                if ((not waiting and not start_wait) and (finished or mobs[i]!=0)) add(selection, i)
            end
        end,

        spawn_enemies = function(_ENV)
            while #enemies < e_cnt and #selection>0 do
                local type=random_select(selection)
                create_enemy(type)
                if not finished then
                    mobs[type]-=1
                    if mobs[type]==0 then
                        del(selection, type)
                    end
                end
            end
        end
    }, {__index=_ENV})
end