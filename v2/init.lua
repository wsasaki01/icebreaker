function _init()
    _g = _ENV

    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {6,5,0.45}, -- player roll

        {129,3,1},
    }

    anim_cnt = 0
    
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
    e_cnt = 5

end