function _init()
    _g = _ENV

    menu = true
    play = false
    retry = false

    cartdata("someguy17-icebreaker-p2")
    h_score = dget(0)
    h_combo = dget(1)

    p = {}
    h = {}

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