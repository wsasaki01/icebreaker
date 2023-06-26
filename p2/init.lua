function _init()
    _g = _ENV

    poke(0x5F2D, 1)
    mouse = true

    menu = true
    play = false
    retry = false

    cartdata("someguy17-icebreaker-p2")
    h_score = format_score(dget(0), dget(1), dget(2))
    h_combo = dget(3)

    mc = 1
    menu_op_len = 2
    menu_op = {
        h_type = 1,
        mod = 1
    }

    h_types = {
        {id=1, name="nORMAL", desc="tHE CLASSIC"},
        {id=2, name="mAGNET", desc="rECALL TO HIT"}
    }

    mods = {
        {id=0, name="nONE", desc=""},
        {id=1, name="gIANT", desc="eASIER TO HIT\nTARGETS, BUT\nUNWEILDY"},
        {id=2, name="tINY", desc="sNIPER SHOT;\nAIM WITH CARE"},
        {id=3, name="mIRROR", desc="tHROW BACKWARDS"}
    }

    p = {}
    h = {}

    h_v_min = 2
    h_magnet_v_min = 0.5
    h_magnet_v_max = 10
    
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
    
    start_cnt = 0
    start_fr = 30

    retry_cnt = 0
    retry_fr = 30

    hit_sign_lim = 4

    roll_stick = false
    throw_stick = false
end