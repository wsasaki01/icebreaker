function _init()
    _g = _ENV

    global_cnt = 0
    anim_cnt = 0

    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {6,5,0.45}, -- player roll

        {129,3,1}, -- hammer spin
    }

    pfp_anim=true
    pfp=false
    pfp_x,pfp_y,pfp_w=8,9,30

    oval_anim = {
        {pfp_w/2-1, -5, pfp_w/2+1, pfp_w+5},
        {-10,pfp_w/2-2,pfp_w+10,pfp_w/2+2},
        {-2,5,pfp_w+2,pfp_w-5},
        {0,0,pfp_w,pfp_w}
    }

    sb=false
    sb_start=0
    sb_current=1
    sb_wait=false
    sb_wait_timer=0
    
    footsteps={}

    tutorial=true
    bound_xl,bound_xu,bound_yl,bound_yu=3,117,tutorial and 50 or 2,115

    --dialogue
    td = {
        "\fdattention!!\n\ntHIS IS \f9cOLONEL\nmAX\fd CALLING.",
        "\fdi'M HERE TO GUIDE\nYOU THROUGH THE\n\f9BASICS OF COMBAT\fd.",
        "\fdlET'S GET TO IT!",
        "\fduSE \f9⬆️⬇️⬅️➡️\fd TO\nMOVE AROUND THE\nBATTLEFIELD.",
        "\fdtO THE RIGHT IS\nA SERVICE WEAPON,\n\f9THE hammer.\n\fdpICK IT UP!",
        "\fdtHROW WITH\n\f9⬆️⬇️⬅️➡️\fd AND \f9🅾️\fd,\nTHEN PICK IT UP\nAGAIN.",
        "\fdgREAT!\ntHROW THE HAMMER\nAT ENEMIES TO\n\f9DESTROY\fd THEM.",
        "\fdaMAZING! yOU SHOW\nGREAT PROMISE...",
        "\fdfINALLY, \f9⬆️⬇️⬅️➡️\fd\nAND \f9❎\fd WHILE\nEMPTY-HANDED TO\n\f9ROLL\fd.",
        "\fdwITH \f9GOOD TIMING\fd,\nYOU CAN ROLL\nTHROUGH ENEMIES\n\f9TAKING NO DAMAGE\fd.",
        "\fdyOU'RE READY FOR\nDEPLOYMENT.\n\f8GOD SPEED,\nRECRUIT\fd!"
    }
end

function initialise_game(init_px,init_py,init_hx,init_hy,init_ecnt)
    -- player
    p_spawned=true
    p_x,p_y = init_px,init_py
    p_move_speed,p_move_multi = 1.2,1
    p_roll,p_roll_timer = false,0

    p_anim,p_flip = 1,false

    -- hammer
    h_x,h_y,h_xw,h_yw = init_hx,init_hy,10,8
    h_v,h_dir,h_h,h_flip = 0,{0,0},0,false

    h_held = false

    -- enemies
    es = {}
    e_cnt = init_ecnt
end