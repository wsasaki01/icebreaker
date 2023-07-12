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

    cartdata("someguy17-icebreaker-p3")
    --0to2=score1-3
    --3=combo record
    --4=hammer
    --5=mod
    h_score = format_score(dget(0), dget(1), dget(2))
    h_combo = dget(3)

    mc = 1
    menu_op_len = 2
    menu_op = {
        h_type = dget(4)!=0 and dget(4) or 1,
        mod = dget(5)!=0 and dget(5) or 1
    }

    h_types = {
        {name="nORMAL", desc="tHE CLASSIC",
        x_hint="ROLL/HIT", o_hint="THROW",},
        {name="mAGNET", desc="rECALL TO\nHIT",
        x_hint="ROLL/HIT", o_hint="THROW/RECALL"},
        {name="tELEPORT", desc="bLINK TO\nHAMMER",
        x_hint="ROLL/HIT", o_hint="THROW/TELEPORT",}
    }

    mods = {
        {name="nONE", desc="",
        perk="vANILLA PLAY", disad="nO PERKS"},
        {name="gIANT", desc="tHREATENING,\nBUT UNWEILDY",
        perk="1.5X SCORE", disad="sLOW"},
        {name="tINY", desc="cHAOTIC, BUT\nDEADLY IN\nDEFT HANDS",
        perk="3.5X SCORE", disad="fAST COMBO\nDECAY"},
        {name="rEVERSE", desc="iT'S GOT YOUR\nBACK!",
        perk="sECURITY", disad="hARDER TO\nRETRIEVE"},
    }

    menu_c={pack=false,lvl=false}
    select=false

    level_tiles={
        {"tutorial", {
            {"iCE bREAK 101", "lEARN THE ROPES!"},
            {"wAVES", "gET READY!"},
            {"cOMBO", "bUILD YOUR SCORE!"}
        }},
        {"magnets", {
            {"aTTRACTION", "tHE POWER OF MAGNETS!"},
            {"mODS", "dESIGN YOUR BUILD!"},
            {"rUSH", "rEADY YOURSELF..."}
        }},
        {"teleport", {
            {"bLINK", "lIKE MAGIC!"},
            {"sPLIT", "tHERE'S SO MANY!"},
            {"fINAL", "tHE LAST CHALLENGE..."}
        }}
    }

    endless=true

    buttons={{}, {}, {}, {}}
    alpha="abcdefghijklmnopqrstuvwxyz"

    local x_pos=5
    local tile_cnt=1
    for tile in all(level_tiles) do
        create_button(x_pos, 15, 1, tile_cnt, 0)
        x_pos+=21
        tile_cnt+=1
    end

    local x_pos=148
    local type_cnt=1
    for type in all(h_types) do
        create_button(x_pos, 15, 3, type_cnt,0)
        x_pos+=20
        type_cnt+=1
    end
    buttons[3][menu_op.h_type].pressed=true

    local y_pos=60
    local mod_cnt=1
    for mod in all(mods) do
        create_button(153, y_pos, 4, mod_cnt,0)
        y_pos+=10
        mod_cnt+=1
    end
    buttons[4][menu_op.mod].pressed=true

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
            clip(2,12,124,109)
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

function get_lvl(pack,lvl)
    local lvls = {
        { -- PACK 1
            { -- 1-1
                {1, "10,0,0"}
            },

            { -- 1-2
                {1, "10,0,0"},
                {2, "10,0,0"},
                {3, "10,2,1"},
                {4, "10,3,3"}
            },

            { -- 1-3
                {3, "20,0,0"},
                {5, "20,5,0"},
                {8, "20,5,2"},
                {10, "30,7,5"},
                {10, "40,8,6"},
                {10, "40,8,6"},
            }
        },

        { -- PACK 2
            { -- 2-1
                {1, "10,0,0"},
                {2, "10,0,0"},
                {4, "20,5,1"},
                {5, "25,5,5"},
                {8, "20,5,5"},
                {8, "20,5,5"},
                {8, "20,5,5"},
                {8, "20,5,5"}
            },

            { -- 2-2
                {1, "5,0,0"},
                {2, "8,0,0"},
                {4, "15,5,5"},
                {5, "20,5,2"},
                {8, "20,5,5"},
                {8, "20,5,5"},
                {8, "20,5,5"},
                {10, "20,5,5"}
            },

            { -- 2-3
                {2, "0,0,6"},
                {3, "0,0,9"},
                {5, "0,0,15"},
                {8, "0,0,30"},
                {10, "0,0,40"},
                {10, "0,0,50"},
                {10, "0,0,50"},
                {12, "0,0,60"},
                {12, "0,0,70"},
                {15, "0,0,70"},
                {15, "0,0,100"},
            },
        },

        { -- PACK 3
            { -- 3-1
                {1, "5,0,0"},
                {2, "6,0,0"},
                {5, "6,2,0"},
                {8, "10,2,2"},
                {8, "10,2,2"},
                {8, "10,2,2"},
            },

            { -- 3-2
                {1, "5,0,0"}
            },

            { --3-3
                {1, "5,3,1"},
                {2, "5,3,3"},
                {3, "10,3,3"},
                {5, "15,10,5"},
                {5, "15,10,5"},
                {6, "15,10,6"},
                {7, "15,5,10"},
                {9, "20,8,10"},
                {10, "30,10,5"},
                {10, "50,10,5"},
                {10, "60,20,15"}
            }
        }
    }

    for i=1, #lvls[pack][lvl] do
        lvls[pack][lvl][i][2]=split(lvls[pack][lvl][i][2])
    end

    return lvls[pack][lvl]
end