function collide(x1,y1,w1,h1,x2,y2,w2,h2)
-- check collision between two rectangles
 return abs(x2+w2/2-x1-w1/2)<=w1/2+w2/2 and abs(y2+h2/2-y1-h1/2)<=h1/2+h2/2
end

function pcollide(x,y,w,h)
    return collide(p_x,p_y+2,7,8,x,y,w,h)
end

function replace_all_col(col)
    for i=0,15 do
        pal(i,col)
    end
end