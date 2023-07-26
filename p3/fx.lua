function create_particle(_x, _y, col, vel)
    local x_gen=_x+flr(rnd(8))-4
    local y_gen=_y+flr(rnd(8))-4
    add(particles, setmetatable({
        d=flr(rnd(2))==0 and 1 or -1,
        dist=vel/5.5,
        x=x_gen,
        y=y_gen,

        og_y=y_gen,
        col=col,
        cnt=0-flr(rnd(3)),
        path={-3,0,3,-2,0,2,-1,0,1},
        stop=false,

        update=function(_ENV)
            cnt+=1
            if cnt>=1 and cnt<=#path then
                x+=dist*d
                y+=path[cnt]
            end
        end,

        draw=function(_ENV)
            if cnt>=1 then
                if (cnt<=#path) pset(x, og_y, 6)
                pset(x, y, col)
            end
        end
    }, {__index=_ENV}))
end

function create_crack(_x, _y, col, _cnt)
    add(cracks, {
        base=gen_crack(_x, _y, 10, 6, col),
        cnt=_cnt,

        decay=function(self)
            self.cnt-=1
            if (self.cnt==0) del(cracks, self)
        end,
        
        draw=function(self)
            if (self.cnt<10) fillp(▒)
            if (self.cnt<5) fillp(░)
            draw_crack(self.base)
            fillp()
        end
    })
end