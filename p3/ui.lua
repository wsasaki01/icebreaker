function log(args)
    for i in all(args) do
        print(i, 0)
    end
end

function rprint(text, x, y, col)
    print(text, x-4*#tostr(text), y, col)
end

function score()
    local score = remove_zero(p:score(true))
    rprint(score, 126, 3, 11)
    rprint(score, 126, 2, 5)

    if p.combo_cnt != 0 then
        rect(33, 7, 33+60*(p.combo_cnt/p.combo_fr), 8, 8)
        rect(33, 9, 33+60*(p.combo_cnt/p.combo_fr), 9, 14)
    end

    if p.multi != p.base_multi then
        pal(6, 2)
        spr(75, 33, 2)
        local multi = tostr(p.multi)
        local pos = 34
        local cnt = 0
        for char in all(multi) do
            cnt += 1
            if char != "." then
                local digit = tonum(char)
                spr(64+digit, pos+5*cnt, 1)
            else
                spr(74, pos+5*cnt, 1)
                pos -= 1
            end
        end

        if multi % 1 == 0 then
            cnt+=1
            spr(74, pos+5*cnt, 1)
            pos-=1
            cnt+=1
            spr(64, pos+5*cnt, 1)
        end
        pal()
    end
end

function create_hit_sign(x, y, num)
    add(hit_signs, setmetatable({
        x = x, y = y,
        num = num,
        cnt = 30,

        draw = function(_ENV)
            rectfill(x-1, y-4, x+1, y+1, 7)
            rectfill(x-11, y-10, x+16, y-4, 7)
            line(x, y, x, y-4, 14)
            print(tostr(num).."X HIT!", x-10, y-9)
        end,

        decay = function(self)
            self.cnt-=1
            if self.cnt%8==0 then
                y-=1
            end
            if self.cnt==0 then
                del(hit_signs, self)
            end
        end
    }, {__index=_ENV}))
end

function create_button(_x, _y, _type, _cnt, _parent_cnt)
    add(buttons[_type], setmetatable({
        x=_x, y=_y,
        xw=_type!=4 and 16 or 8, yw=_type!=4 and 16 or 8,
        pressed=false,
        type=_type,
        cnt=_cnt,
        parent_cnt=_parent_cnt,

        check=function(_ENV)
            if collide(
                p.x+2, p.y+6, p.xw-4, p.yw-6,
                x, y, xw, yw
            ) and not pressed then
                pressed=true
                local index=1
                for button in all(buttons[type]) do
                    if (index!=cnt) button.pressed=false
                    index+=1
                end

                if type==1 then
                    menu_c.pack=cnt
                    menu_c.lvl=false
                    buttons[2]={}
                    local y_pos=40
                    local tile_cnt=1
                    for tile in all(level_tiles[cnt][2]) do
                        create_button(5, y_pos, 2, tile_cnt, cnt)
                        y_pos+=18
                        tile_cnt+=1
                    end
                end

                if (type==2) menu_c.lvl=cnt
                if (type==3) dset(4, cnt) menu_op.h_type=cnt
                if (type==4) dset(5, cnt) menu_op.mod=cnt
            end
        end,

        draw=function(_ENV)
            local cols={14,15,12,9}
            pal(7,cols[type])
            if type==4 then
                local info=mods[cnt]
                spr(pressed and 124 or 123, x, y)
                print(info.name, x+10, y+2, pressed and 9 or 6)
                if pressed then
                    print(info.desc.."\n", 197, 60)
                    print(info.perk, 3)
                    print(info.disad, 8)
                end
            else
                sspr(pressed and 72 or 56, 40, 16, 16, x, y, xw, yw)
                if type==1 then
                    pal(6, 2)
                    spr(64+cnt, x+5, y+(pressed and 6 or 3))
                    pal()
                    if pressed then
                        print(level_tiles[cnt][1], 5, 32, 14)
                    end
                elseif type==2 then
                    print(alpha[cnt], x+6, y+(pressed and 7 or 4), 4)
                    if pressed then
                        local info=level_tiles[parent_cnt][2][cnt]
                        print(parent_cnt..alpha[cnt].." \^i"..info[1].."\n", 28, 45, 12)
                        print(info[2].."\n", 9)
                        print("wAVES: "..#get_lvl(parent_cnt,cnt))
                    end
                elseif type==3 then
                    spr(159+cnt, x+4, y+(pressed and 5 or 2))
                    if pressed then
                        local info=h_types[cnt]
                        print("\^i\^t\^w"..info.name, 150, 37, 1)
                        print(info.desc, 154+8*#info.name, 37, 1)
                    end
                end
            end
            pal()
        end
    }, {__index=_ENV}))
end