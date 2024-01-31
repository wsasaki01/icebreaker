function _init()
    _g = _ENV

    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {6,5,0.45}, -- player roll

        {129,3,1}, -- hammer spin
    }

    sb=true
    sb_start=0
    sb_x,sb_y,sb_w=8,9,30

    oval_anim = {
        {sb_w/2-1, -5, sb_w/2+1, sb_w+5},
        {-10,sb_w/2-2,sb_w+10,sb_w/2+2},
        {-2,5,sb_w+2,sb_w-5},
        {0,0,sb_w,sb_w}
    }

    anim_cnt = 0
    footsteps={}

    tutorial=true
    bound_xl,bound_xu,bound_yl,bound_yu=3,117,tutorial and 50 or 2,115

    -- player
    p_x,p_y = 50,50
    p_move_speed,p_move_multi = 1.2,1
    p_roll,p_roll_timer = false,0
    
    p_anim,p_flip = 1,false

    -- hammer
    h_x,h_y,h_xw,h_yw = 10,7,10,8
    h_v,h_dir,h_h,h_flip = 0,{0,0},0,false

    h_held = false

    -- enemies
    es = {}
    e_cnt = 0

    --dialogue
    td = {
        "ok, RECRUIT,\nYOU'RE DROPPING IN TO TRAINING now"
    }
end