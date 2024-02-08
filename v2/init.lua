function _init()
    _g = _ENV

    shake_enabled=true
    sh_str=0

    global_cnt = 0
    anim_cnt = 0

    continue=0
    trans,trans_cnt=false,0
    sheet_start=0
    selected,options_selected=1,1

    levels={
        {"\f1tRAINING",30,0,{}},
        {"\f1fIRST cONTACT",50,30,{{10,1},{10,1},{20,1}}},
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
    c_x,c_y=0,0
    c_x_target,c_y_target=0,0
    outro_start=-1

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

    t_sb_current=13
    t_sb_wait_timer=0
    big_combo_print=0
    
    wind={}

    --dialogue
    td = {
        "\f1attention!!\n\n\fdtHIS IS \f9cOLONEL\nmAX\fd CALLING.",
        "\fdi'M HERE TO GUIDE\nYOU THROUGH THE\n\f9BASICS OF COMBAT\fd.",
        "\fdlET'S GET TO IT!",
        "\fduSE \f9⬆️⬇️⬅️➡️\fd TO\nMOVE AROUND THE\nBATTLEFIELD.",
        "\fdtO THE RIGHT IS\nA SERVICE WEAPON,\n\f9THE hammer.\n\fdpICK IT UP!",
        "\fdtHROW WITH\n\f9⬆️⬇️⬅️➡️\fd AND \f9🅾️\fd,\nTHEN PICK IT UP\nAGAIN.",
        "\fdgREAT!\ntHROW THE HAMMER\nAT ENEMIES TO\n\f9DESTROY\fd THEM.",
        "\fdaMAZING! yOU SHOW\nGREAT PROMISE...",
        "\fdfINALLY, \f9⬆️⬇️⬅️➡️\fd\nAND \f9❎\fd WHILE\nEMPTY-HANDED TO\n\f9ROLL\fd.",
        "\fdwITH \f9GOOD TIMING\fd,\nYOU CAN ROLL\nTHROUGH ENEMIES\n\f9TAKING NO DAMAGE\fd.",
        "\fdtAKE AS MUCH TIME\nAS YOU NEED TO\nPRACTICE THESE\nSKILLS.",
        "\fdwHEN YOU'RE READY\nTO LEAVE, HEAD TO\nTHE \f8EVAC ZONE\fd.\ngOOD LUCK!",
    }
end

function initialise_menu(p)
    menu,play,tutorial=true,false,false
    page,sheet_start=p,global_cnt
    p_spawned,t_pfp_shown,t_pfp_anim,heli=false,false,false,false
    c_x,c_x_target,c_y,c_y_target=1000,levels[selected][2]-64,0,0
    outro_start=-1
end

function initialise_game(lvl_data)
    lvl=lvl_data[4]
    wave,wave_cnt=1,#lvl

    bound_xl,bound_xu,bound_yl,bound_yu=3,117,tutorial and 50 or 2,115
    c_x_target,c_y_target=54,64

    -- player
    p_spawned=true
    p_x,p_y = 40,60
    p_move_speed,p_move_multi = 1.4,1
    p_roll,p_roll_timer = false,0
    p_anim,p_flip = 1,false
    p_health,p_inv_cnt=3,-1
    p_score1,p_score2,p_combo,p_combo_cnt=0,0,0,0

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
    heli=false
    pickup=false
    outro_start=-1
    heli_x,heli_y=-60,50
    heli_x_target,heli_y_target=56,40
end

function initialise_tutorial()
    tutorial=true
    p_spawned=false

    t_pfp_shown=false
    t_pfp_anim=false
    t_pfp_start=global_cnt
    t_pfp_x,t_pfp_y,t_pfp_w=8,9,30

    t_sb_shown=false
    t_sb_current=1    -- which line?
    t_sb_start=0      -- records starting frame, for revealing text
    t_sb_wait=false   -- waiting for button input?
    t_sb_wait_timer=0 -- automatic timer, in place of button input
end