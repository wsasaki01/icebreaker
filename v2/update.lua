function _update()
    if (btn(0) and p.x > 0)   p.x -= 1
    if (btn(1) and p.x < 120) p.x += 1
    if (btn(2) and p.y > 0)   p.y -= 1
    if (btn(3) and p.y < 120) p.y += 1
end