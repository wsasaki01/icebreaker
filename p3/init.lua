function _init()
    _g = _ENV

    poke(0x5F2D, 1)
    mouse = false

    diff={x=0,y=0}

    hub=true
    config=false
    play=false
    retry=false
    finished=false

    cartdata("someguy17-icebreaker-p4")
    --0to2=score1-3
    --3=combo record
    --4=hammer
    --5=mod

    unlocked=dget(2)

    mc = 1
    menu_op_len = 2
    menu_op = {
        h_type = dget(0)!=0 and dget(0) or 1,
        mod = dget(1)!=0 and dget(1) or 1
    }

    gen_lvl_info()

    menu_c={pack=false,lvl=false}
    select=false

    endless=false

    alpha="abcdefghijklmnopqrstuvwxyz"

    gen_btns()

    starter=setmetatable({
        x=105,y=100,
        r=10, r_max=125,
        active=false,
        check=function(_ENV)
            if (play) return
            active=menu_c.pack!=false and menu_c.lvl!=false
            if active then
                if collide(
                    p.x,p.y,p.xw,p.yw,
                    x,y,15,15
                ) then
                    r*=1.07
                    sfx(19)
                else
                    r/=2
                    if r<10 then
                        r=10
                    end
                end

                if r>r_max then
                    r=10
                    start_game()
                end
            end
        end,

        draw=function(_ENV)
            if (active) print("go! ▶", 75+sin(fr/50)*5, 103, 13)
            clip(2,12,124,108)
            circfill(x+5,y+5,r,12)
            circfill(x+5,y+5,10,active and 1 or 6)
            circ(x+5,y+5,8,active and 13 or 12)
            clip()
        end
    }, {__index=_ENV})

    transition=false
    tran_cnt=0
    tran_fr=20

    p = create_player(menu_op.h_type, menu_op.mod)
    h = create_weapon(menu_op.h_type, menu_op.mod)

    reset_tbls()

    fr=0

    bounds = {{x=2, y=10}, {x=126, y=119}}
    config_bounds={{x=130,y=10}, {x=254,y=119}}

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

function reset_tbls()
    particles={}
    cracks={}
    float_scores={}

    attacks = {}
    enemies = {}
    hit_signs = {}
    hearts = {}
end

function get_lvl(_pack,_lvl)
    local lvl_txt=[[
        1-10/0/0,
        1-10/0/0 | 2-10/0/0 | 3-10/2/1 | 4-10/3/3,
        3-20/0/0 | 5-20/5/0 | 8-20/5/2 | 10-30/7/5 | 10-40/8/6 | 10-40/8/6
        ;
        1-10/0/0 | 2-10/0/0 | 4-20/5/1 | 5-25/5/5 | 8-20/5/5 | 8-20/5/5 | 8-20/5/5 | 80/20/5/5,
        1-5/0/0 | 2-8/0/0 | 4-15/5/5 | 5-20/5/2 | 8-20/5/5 | 8-20/5/5 | 8-20/5/5 | 10-20/5/5,
        2-0/0/6 | 3-0/0/9 | 5-0/015 | 8-0/0/30 | 10-0/0/40 | 10-0/0/50 | 10-0/0/50 | 12-0/0/60 | 12-0/0/70 | 15-0/0/70 | 15-0/0/100
        ;
        1-5/0/0 | 2-6/0/0 | 5-6/2/0 | 8-10/2/2 | 8-10/2/2 | 8-10/2/2,
        1-5/0/0,
        1-5/3/1 | 2-5/3/3 | 3-10/3/3 | 5-15/10/5 | 5-15/10/6 | 6-15/10/6 | 7-15/5/10 | 9-20/8/10 | 10-30/10/5 | 10-50/10/5 | 12-60/20/15
    ]]

    local lvls=split(lvl_txt, ";")
    for p_k,pack in pairs(lvls) do
        lvls[p_k]=split(pack, ",")
        for l_k,lvl in pairs(lvls[p_k]) do
            lvls[p_k][l_k]=split(lvl, "|")
            for w_k,wave in pairs(lvls[p_k][l_k]) do
                lvls[p_k][l_k][w_k]=split(wave, "-")
                lvls[p_k][l_k][w_k][2]=split(lvls[p_k][l_k][w_k][2], "/")
            end
        end
    end

    return lvls[_pack][_lvl]
end

function gen_lvl_info()
    level_tiles={
        {"tutorial", {
            {"iCE bREAK 101", "lEARN THE ROPES!", true, "00000000", 0},
            {"wAVES", "gET READY!", unlocked>1, "00000000", 0},
            {"cOMBO", "bUILD YOUR SCORE!", unlocked>2, "00000000", 0}
        }},
        {"magnets", {
            {"aTTRACTION", "tHE POWER OF MAGNETS!", unlocked>3, "00000000", 0},
            {"mODS", "dESIGN YOUR BUILD!", unlocked>4, "00000000", 0},
            {"rUSH", "rEADY YOURSELF...", unlocked>5, "00000000", 0}
        }},
        {"teleport", {
            {"bLINK", "lIKE MAGIC!", unlocked>6, "00000000", 0},
            {"sPLIT", "tHERE'S SO MANY!", unlocked>7, "00000000", 0},
            {"fINAL", "tHE LAST CHALLENGE...", unlocked>8, "00000000", 0}
        }}
    }
    cnt=1
    for pack in all(level_tiles) do
        for lvl in all(pack[2]) do
            lvl[4]=format_score(dget(3+(cnt-1)*6), dget(4+(cnt-1)*6))
            lvl[5]=dget(7+(cnt-1)*6)
            cnt+=1
        end
    end

    h_types = {
        {name="nORMAL", desc="tHE CLASSIC",
        x_hint="ROLL/HIT", o_hint="THROW", got=true},
        {name="mAGNET", desc="rECALL TO\nHIT",
        x_hint="ROLL/HIT", o_hint="THROW/RECALL", got=unlocked>3},
        {name="tELEPORT", desc="bLINK TO\nHAMMER",
        x_hint="ROLL/HIT", o_hint="THROW/TELEPORT", got=unlocked>6}
    }

    mods = {
        {name="nONE", desc="",
        perk="vANILLA PLAY", disad="nO PERKS", got=true},
        {name="gIANT", desc="tHREATENING,\nBUT UNWEILDY",
        perk="1.5X SCORE", disad="sLOW", got=unlocked>5},
        {name="tINY", desc="cHAOTIC, BUT\nDEADLY IN\nDEFT HANDS",
        perk="3.5X SCORE", disad="fAST COMBO\nDECAY", got=unlocked>5},
        {name="rEVERSE", desc="iT'S GOT YOUR\nBACK!",
        perk="sECURITY", disad="hARDER TO\nRETRIEVE", got=unlocked>4},
    }
end

function get_lvl_info()
    return level_tiles[menu_c.pack][2][menu_c.lvl]
end

function get_mem_loc()
    if (not menu_c.pack or not menu_c.lvl) return false
    return 3+(menu_c.pack-1)*18+(menu_c.lvl-1)*6
end

function gen_btns()
    buttons={{}, {}, {}, {}}
    local x_pos=5
    for tile_cnt,tile in pairs(level_tiles) do
        local flag=false
        local lvl_cnt=1
        for lvl_cnt,lvl in pairs(tile[2]) do
            if (lvl[3]) flag=true
            local mem=3+(tile_cnt-1)*18+(lvl_cnt-1)*6
            lvl[4]=format_score(dget(mem), dget(mem+1))
        end
        create_button(x_pos, 15, 1, tile_cnt, 0, flag)
        x_pos+=21
    end

    local x_pos=148
    for type_cnt,type in pairs(h_types) do
        create_button(x_pos, 15, 3, type_cnt,0, type.got)
        x_pos+=20
    end
    buttons[3][menu_op.h_type].pressed=true

    local y_pos=60
    for mod_cnt,mod in pairs(mods) do
        create_button(153, y_pos, 4, mod_cnt,0, mod.got)
        y_pos+=10
    end
    buttons[4][menu_op.mod].pressed=true
end