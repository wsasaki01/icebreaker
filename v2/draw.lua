function _draw()
    cls(7)
    spr(anims[p_anim][p_anim_cnt], p_x, p_y)

    if (h_unheld) spr(128, h_x, h_y)
    --rect(p_x,p_y+2,p_x+7,p_y+8)
    --rect(h_x,h_y,h_x+h_xw,h_y+h_yw)
end