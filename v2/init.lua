function _init()
    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {5,6,1},    -- player roll
    }

    anim_cnt = 0
    
    -- player
    p_x = 50 p_y = 50
    p_roll = false
    p_roll_timer = 0
    
    p_anim = 1
    p_flip = false

    h_x = 10 h_xw = 7
    h_y = 10 h_yw = 8

    -- hammer
    h_unheld = true

end