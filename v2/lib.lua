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

--text,xpos,ypos,color
function wide_print(t,x,y,c)
    c=c or 13
    t=t..""
    for i=0,#t-1 do
        local _x,_t,_c=x+i*5,t[i+1],{}
        for p=0,4 do 
            add(_c,pget(_x+2,y+p))
        end
        print(_t,_x,y,c)
        for p=0,4 do
            pset(_x+2,y+p,_c[p+1])   
        end
        print(_t,_x+1,y,c)
    end
end