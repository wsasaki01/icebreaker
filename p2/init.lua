function _init()
    _g = _ENV

    thing1 = "000000000011"
    thing2 = "000000000010"

    menu = true
    play = false
    retry = false

    cartdata("someguy17-icebreaker-p2")
    h_score = format_score(dget(0), dget(1), dget(2))
    h_combo = dget(3)

    p = {}
    h = {}
    h_type = 1
    h_type_no = 2

    h_types = {
        "normal",
        "magnet"
    }

    p_a_len = 0.3
    p_a_size = 7

    h_a_len = 0.3
    h_a_size = 4
    h_v_min = 2
    h_magnet_v_min = 0.5
    
    magnet_multi = 1.25

    e_init_cnt = 1
    e_s_min = 0.4
    e_s_max = 1
    e_range = e_s_max - e_s_min

    sh_str1 = 0
    sh_str2 = 0
    sh_str3 = 0

    hs = 0 -- 0 for not, num for frame count
    hs_cnt = 0
    
    retry_cnt = 0
    retry_fr = 30

    hit_sign_lim = 4

    roll_stick = false
    throw_stick = false
end