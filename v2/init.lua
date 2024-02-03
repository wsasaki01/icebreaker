function _init()
    _g = _ENV

    global_cnt = 0
    anim_cnt = 0

    continue=0

    splash=false
    menu=true
    tutorial=false
    play=false

    p_spawned=false

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
        {14,-5,16,35},
        {-10,13,40,17},
        {-2,5,32,25},
        {0,0,30,30}
    }

    t_sb_current=13
    t_sb_wait_timer=0
    big_combo_print=0
    
    footsteps={}

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

function initialise_game(init_px,init_py,init_hx,init_hy,init_ecnt,init_econccnt,init_respawn)
    -- camera
    c_x,c_y=50,56

    bound_xl,bound_xu,bound_yl,bound_yu=3,117,tutorial and 50 or 2,115

    -- player
    p_spawned=true
    p_x,p_y = init_px,init_py
    p_move_speed,p_move_multi = 1.2,1
    p_roll,p_roll_timer = false,0
    p_anim,p_flip = 1,false
    p_health=3
    p_score1,p_score2,p_combo,p_score_inc=0,0,0,0

    -- hammer
    h_x,h_y,h_xw,h_yw = init_hx,init_hy,10,8
    h_v,h_dir,h_h,h_flip = 0,{0,0},0,false
    h_held = false

    -- enemies
    es = {}
    e_cnt=init_ecnt
    e_spawn_cnt=0
    e_killed_cnt=0
    e_conc_limit = init_econccnt
    e_spawn_interval = init_respawn
    e_spawn_timer = 0
end

function initialise_tutorial()
    t_pfp_shown=false
    t_pfp_anim=false
    t_pfp_start=0
    t_pfp_x,t_pfp_y,t_pfp_w=8,9,30

    t_sb_shown=false
    t_sb_current=1    -- which line?
    t_sb_start=0      -- records starting frame, for revealing text
    t_sb_wait=false   -- waiting for button input?
    t_sb_wait_timer=0 -- automatic timer, in place of button input
end