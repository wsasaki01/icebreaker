function start_game()
    dset(4, menu_op.h_type)
    dset(5, menu_op.mod)

    p = create_player(menu_op.h_type, menu_op.mod)
    h = create_weapon(menu_op.h_type, menu_op.mod)

    particles={}

    e_cnt = e_init_cnt
    attacks = {}
    enemies = {}
    hit_signs = {}
    hearts = {}

    sh_str1 = 0
    sh_str2 = 0
    sh_str3 = 0

    wave=1

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