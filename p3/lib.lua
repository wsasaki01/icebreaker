function collide(x1,y1,w1,h1,x2,y2,w2,h2)
-- check collision between two rectangles
    return abs((x2+(w2/2))-(x1+(w1/2)))<=(w1/2)+(w2/2) and abs((y2+(h2/2))-(y1+(h1/2)))<=(h1/2)+(h2/2)
end

function shake(cx,cy,sh_str)
-- apply screen shake
    camera((cx+20-rnd(40))*sh_str, (cy+20-rnd(40))*sh_str)
    sh_str *= 0.75
    if (sh_str < 0.05) sh_str = 0
    return sh_str
end

function gen_crack(cx,cy,strand_cnt,max_seg_length,col)
-- generate a cracked-ice effect
    local out={{x=cx,y=cy},col,{}}
    for i=1,strand_cnt do
        local s={}
        local dir=rnd(1)
        local x=cx
        local y=cy
        for i=1,flr(rnd(10))+1 do
            x+=cos(dir+rnd(0.25)-0.125)*rnd(max_seg_length)
            y+=sin(dir+rnd(0.25)-0.125)*rnd(max_seg_length)
            add(s,{x, y})
        end
        add(out[3],s)
    end
    return out
end

function draw_crack(crack)
-- draw the ice crack
    local c=crack[1]
    for s in all(crack[3]) do
        line(c.x,c.y,c.x,c.y,crack[2])
        for ep in all(s) do
            line(ep[1],ep[2],crack[2])
        end
    end
end