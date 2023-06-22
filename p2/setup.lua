function start_game()
    p = create_player()
    h = create_weapon()

    e_cnt = e_init_cnt
    attacks = {}
    enemies = {}
    hit_signs = {}
    hearts = {}

    sh_str1 = 0
    sh_str2 = 0

    force_queue = setmetatable({
        q = {},
        enqueue = function(_ENV, item)
            add(q, item)
        end,
        dequeue = function(_ENV)
            if #q == 0 then
                return -1
            else
                local out = q[1]
                del(q, out)
                return out
            end
        end

    }, {__index=_ENV})
end