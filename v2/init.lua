function _init()
    _g = _ENV

    shake_enabled=true
    sh_str=0

    global_cnt = 0
    anim_cnt = 0

    continue=0
    trans_cntr=-1
    selected,options_selected=1,1

    levels={
        {"\f1tRAINING",30,0,{{0,0}}},
        --{"\f1fIRST cONTACT",50,30,{{10,1},{10,1},{20,1}}},
        {"\f1fIRST cONTACT",50,30,{{1,1}}},
        {"\f1eRIF rESCUE",90,20,{{20,2},{20,2},{20,3}}},
        {"\f1mOUNTAINS",120,0},
        {"\f1iCE pEAK",160,10},
        {"\f1cOLD bLAST",195,-30},
        {"\f1fACTORY sHUTDOWN",230,0}
    }

    settings_options={
        {"\f1sCREEN sHAKE",-16,164,true},
        {"\f1mOVING cAM",4,174,true},
    }

    splash=false
    menu,page=true,2
    tutorial=false
    play,heli=false,false

    p_spawned=false
    p_roll_cntr=-1
    p_inv_cntr=-1
    p_combo_cntr=-1
    pfp_cntr=-1
    c_x,c_y=0,0
    c_x_target,c_y_target=0,0
    outro_cntr=-1

    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {6,5,0.45}, -- player roll

        {129,3,1}, -- hammer spin
    }

    oval_anim = {
        {-10,-10,-10,-10},
        {14,-5,16,35},
        {-10,13,40,17},
        {-2,5,32,25},
        {0,0,30,30}
    }

    sb_current=1
    sb_cntr=-1
    sb_auto_cntr=-1
    big_combo_print=0
    
    particles={}
    dwash_cnt=0

    --dialogue
    d = {
        { -- 1: tutorial
            "\f1attention!!\n\n\fdtHIS IS \f9cOLONEL\nmAX\fd CALLING.",
            "\fdi'M HERE TO GUIDE\nYOU THROUGH THE\n\f9BASICS OF COMBAT\fd.",
            "\fdlET'S GET TO IT!",
            "\fduSE \f9⬆️⬇️⬅️➡️\fd TO\nMOVE AROUND THE\nBATTLEFIELD.",
            "\fdtO THE RIGHT IS\nA SERVICE WEAPON,\n\f9THE hammer.\n\fdpICK IT UP!",
            "\fdtHROW WITH\n\f9⬆️⬇️⬅️➡️\fd AND \f9🅾️\fd,\nTHEN PICK IT UP\nAGAIN.",
            "\fdgREAT!\ntHROW THE HAMMER\nAT ENEMIES TO\n\f9DESTROY\fd THEM.",
            "\fdaMAZING! lET ME\nEXPLAIN THESE\n\f9STATS\fd YOU CAN\nSEE.",
            "\fdtHERE'S YOUR\n\f9HEALTH VIAL \fdAT\nTHE TOP; 3 HITS\nAND YOU'RE DOWN.",
            "\fdtHE \f3NUMBER\fd'S YOUR\n\f9SCORE\fd; WE TRACK\nIT FOR METRICS\nAND EVALUATIONS.",
            "\fdaT THE BOTTOM IS\nYOUR \f9COMBO\fd.\nKILL ENEMIES TO\nINCREASE IT!", 
            "\fdyOU GET HIGHER\nSCORES IF YOU\nHAVE A HIGHER\nCOMBO.",
            "\fdbUT YOU LOSE IT\nIF YOU DON'T KILL\nENEMIES \f9QUICKLY\fd,\nOR IF YOU'RE \f9HIT\fd.",
            "\fdoK! fINALLY,\n\f9⬆️⬇️⬅️➡️\fd AND \f9❎\fd\nWHILE EMPTY-\nHANDED \f9TO ROLL\fd.",
            "\fdwITH \f9GOOD TIMING\fd,\nYOU CAN ROLL\nTHROUGH ENEMIES\n\f9TAKING NO DAMAGE\fd.",
            "\fdtAKE AS MUCH TIME\nAS YOU NEED TO\nPRACTICE THESE\nSKILLS.",
            "\fdwHEN YOU'RE READY\nTO LEAVE, HEAD TO\nTHE \f8EVAC ZONE\fd.\ngOOD LUCK!",
        },
        { -- 2: first contact
            "yOU'RE HEADED TO\nTHE OUTSKIRTS OF\nTHE FRONT LINE.",
            "oUR READINGS\nINDICATE MINIMAL\nENEMY ACTVIVTY,",
            "SO IT'S A GREAT\nPLACE TO TRY YOUR\nHAND AT REAL\nCOMBAT.",
            "gOOD LUCK,\nRECRUIT!",
            "tHAT WAT SOME GREAT WORK, RECRUIT.",
            "lET'S HEAD BACK TO BASE."
        }
    } 
end

function initialise_menu(p)
    menu,play,tutorial=true,false,false
    page=p
    sb_current=1
    sb_cntr,p_spawned,pfp_cntr,shown,heli=-1,false,-1,false,false
    c_x,c_x_target,c_y,c_y_target=1000,levels[selected][2]-64,0,0
    outro_cntr=-1
end

function initialise_game()
    lvl=levels[selected][4]
    wave,wave_cnt=1,#lvl

    bound_xl,bound_xu,bound_yl,bound_yu=3,117,tutorial and 61 or 2,115
    c_x_target,c_y_target=-90,20

    -- player
    p_spawned=false
    p_x,p_y=-103,50
    p_move_speed = 1.4
    p_roll_cntr = -1
    p_anim,p_flip = 1,false
    p_health,p_inv_cntr=3,-1
    p_score1,p_score2,p_combo,p_combo_cntr=0,0,0,-1

    -- hammer
    h_x,h_y,h_xw,h_yw = 60,60,10,8
    h_v,h_dir,h_h,h_flip = 0,{0,0},0,false
    h_held = false

    -- enemies
    es = {}
    e_wave_cnt=lvl[1][1]
    e_total_cnt=0
    e_spawn_cnt=0
    e_killed_cnt=0
    e_conc_limit = lvl[1][2]
    e_spawn_interval = 15
    e_spawn_timer = 0
    
    -- heli
    heli=true
    pickup=false
    outro_cntr=-1
    heli_x,heli_y=-120,0
    heli_x_target,heli_y_target=-120,0 --56,40

    intro=true
    intro_phase=1
    p_dropping,h_dropping=false,false

    start_pfp()
end

function initialise_tutorial()
    tutorial=true
    p_spawned=false
    t_rolled=false
    t_thrown=false

    initialise_game()

    heli,intro=false,false
    p_x,p_y=40,90
    h_x,h_y=100,90
    c_x_target,c_y_target=72,48 --72,48

    start_pfp()

    sb_current=1    -- which line?
    sb_cntr=-1
    sb_wait=false   -- waiting for button input?
    sb_auto_cntr=-1 -- automatic timer, in place of button input
end

function start_pfp()
    pfp_cntr=-1
    pfp_x,pfp_y,pfp_w=8,22,30
end