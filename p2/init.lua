function _init()
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

    e_init_cnt = 5
    e_s_min = 0.4
    e_s_max = 1
    e_range = e_s_max - e_s_min

    sh_str1 = 0
    sh_str2 = 0

    hs = false
    hs_cnt = 0
    hs_frames = 3
    
    retry_cnt = 0
    retry_fr = 30

    hit_sign_lim = 4
end