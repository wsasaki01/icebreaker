function collide(x1,y1,w1,h1,x2,y2,w2,h2)
-- check collision between two rectangles
    return abs((x2+(w2/2))-(x1+(w1/2)))<=(w1/2)+(w2/2) and abs((y2+(h2/2))-(y1+(h1/2)))<=(h1/2)+(h2/2)
end

function raycast(x0,y0,x1,y1,cx,cy)
-- raycast from point 0 to point 1, within camera bounds
    local a=atan2(x1-x0,y1-y0)
    local rc={{x0, y0}}
    local xi=cos(a)>=0 and 1 or -1
    local yi=sin(a)>=0 and 1 or -1
    local x=x0
    local y=y0
    local p={x0, y0}
    while cx<=p[1] and p[1]<=cx+128 and cy<=p[2] and p[2]<=cy+128 do
    local nv=p[1]+1
    local nh=p[2]+1
    local xd=(nv-x)/cos(a)
    local yd=(nh-y)/sin(a)
    if xd<yd then
    p[1]+=xi
    y+=(sin(a)/cos(a))*(nv-x)
    x=nv
    else
    p[2]+=yi
    x+=(nh-y)/(sin(a)/cos(a))
    y=nh
    end
    local s={}
    for c in all(p) do
    add(s,c)
    end
    add(rc,s)
    end
    return rc
end

function shake(cx,cy)
-- apply screen shake
    camera((cx+20-rnd(40))*sh_str, (cy+20-rnd(40))*sh_str)
    sh_str *= 0.75
    if (sh_str < 0.05) sh_str = 0
end