function _init()
    _g = _ENV

    poke(0x5F2D, 1)
    mouse = false

    diff={x=0,y=0}

    title=true
    menu = false
    play = false
    retry = false
    finished=false

    cartdata("someguy17-icebreaker-p3")
    --0to2=score1-3
    --3=combo record
    --4=hammer
    --5=mod
    h_score = format_score(dget(0), dget(1), dget(2))
    h_combo = dget(3)

    fr=0

    mc = 1
    menu_op_len = 2
    menu_op = {
        h_type = dget(4)!=0 and dget(4) or 1,
        mod = dget(5)!=0 and dget(5) or 1
    }

    h_types = {
        {name="nORMAL", desc="tHE CLASSIC",
        x_hint="ROLL/HIT", o_hint="THROW",},
        {name="mAGNET", desc="rECALL TO HIT",
        x_hint="ROLL/HIT", o_hint="THROW/RECALL"},
        {name="tELEPORT", desc="bLINK TO HAMMER",
        x_hint="ROLL/HIT", o_hint="THROW/TELEPORT",}
    }

    mods = {
        {name="nONE", desc="",
        perk="vANILLA PLAY", disad="nO PERKS"},
        {name="gIANT", desc="tHREATENING, BUT\nUNWEILDY",
        perk="1.5X SCORE", disad="sLOW"},
        {name="tINY", desc="cHAOTIC, BUT DEADLY\nIN DEFT HANDS",
        perk="3.5X SCORE", disad="fAST COMBO DECAY"},
        {name="rEVERSE", desc="iT'S GOT YOUR\nBACK!",
        perk="sECURITY", disad="hARDER TO RETRIEVE"},
        {name="gUIDE", desc="a HELPING HAND",
        perk="fORESIGHT", disad=""}
    }

    menu_c={pack=1,lvl=1}
    select=false

    level_tiles={
        {"tutorial", {"iCE bREAK 101", "wAVES", "cOMBO"}},
        {"magnets", {"aTTRACTION", "mODS", "rUSH"}},
        {"teleport", {"bLINK", "sPLIT"}}
    }

    p = {}
    h = {}

    bounds = {{x=2, y=10}, {x=126, y=119}}

    h_v_min = 2
    h_magnet_v_min = 0.5
    h_magnet_v_max = 10
    
    magnet_multi = 1.25

    e_s_min = 0.4
    e_s_max = 1
    e_s_range = e_s_max - e_s_min
    
    e_s_bounds={{e_s_min, 0.8}, {0.8, 0.9}, {0.9, e_s_max}}

    max_particles=40

    sh_str1 = 0
    sh_str2 = 0
    sh_str3 = 0

    hs = 0 -- 0 for not, num for frame count
    
    start_cnt = 0
    start_fr = 30

    retry_cnt = 0
    retry_fr = 30

    return_cnt = 0
    return_fr = 30

    hit_sign_lim = 4

    x_stick = false
    o_stick = false
end

function get_lvl(pack,lvl)
    return {
        { -- PACK 1
            { -- 1-1
                {1, {5, 3, 1}},
                {2, {5, 3, 3}},
                {3, {10, 3, 3}},
                {5, {15, 10, 5}},
                {5, {15, 10, 5}},
                {6, {15, 10, 6}},
                {7, {15, 5, 10}},
                {9, {20, 8, 10}},
                {10, {30, 10, 5}},
                {10, {50, 10, 5}},
                {10, {60, 20, 15}}
            }
        }
    }
end