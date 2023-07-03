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

        check_wave=function(_ENV)
            if (#enemies>0) return

            local flag=true
            for item in all(mobs) do
                if (item!=0) flag=false
            end

            if flag then
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
                if (finished or mobs[i]!=0) add(selection, i)
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