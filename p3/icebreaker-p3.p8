pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include init.lua
#include update.lua
#include draw.lua
#include ui.lua
#include setup.lua
#include player.lua
#include enemy.lua
#include weapon.lua
#include damage.lua
#include drops.lua
#include fx.lua
#include lib.lua
__gfx__
000000000000000000000000000000000000000000000000000d0880000d00800000100000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000002288000222880000000000000100000000000000000000000000000000000000000000000000
007007000008e0000008e0000008e0000008e000000000000002277e0022277e01000000000000008800d0000000000000000000000000000000000000000000
0007700000888e0000888e0000888e0000888e000000000000222220102222270000222000000221872000000000000000000000000000000000000000000000
00077000002277000022770d00227700d0227700000000001022200d0022002000022222d0002220872002100000000000000000000000000000000000000000
00700700d022220dd0222200d022220d0022220d000000000000000001000000000000220077222022d222000000000000000000000000000000000000000000
000000000022220000222200002222000022220000000000001000000000000d0d00772800e72200022222010000000000000000000000000000000000000000
0000000000100100001001000010010000100100000000000000000000000000000de8800d088000002220000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000008e00000088e0000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000008e000008e000000888e00008888e0000088e000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000888e000888e0000882770000d0278e0d02778e00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000227700022770d0d002220d000022200002228000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d022220d02222000000222000012222d00222d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000222200d022210000122100000222000122200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001001000010000000000000000010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000008e0000008e0000008e0000008e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100888e0100888e0100888e0100888e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001002277d1002277010022770100227700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001111d2201111d2201111d22d1111d2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100222201002222d100222201002222d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100100101001001010010010100100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000008e00000008e000000080000008e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100888e00100888e001008880100888e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100227700102277701002778010022770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111d2220011d22220111d227011d22220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100222201002222010022222010222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000100100101010010010100010010100200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600006000000666000066600000000600006666600006666000666000000666000006600000000000006000600000000000000000000000000000011000
06000600066000006000600000060000006600006000000060000000000600006000600060060000000000000606000006600dd0000000000000000000011000
60000600606000000000600006600000060600006666000066660000000600000666000060060000000000000060000060666d06000000000000000000011000
60000600006000000066000000060000666660000000600060006000006000006000600006660000000000000606000060066006000000000000000000011000
60006000006000000600000000060000000600000000600060006000006000006000600000060000066000006000600060066006000000000000000000011000
66666000666660006666600066600000000600006666000006660000006000000666000066600000066000000000000060d66606000000000000000001111110
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd00660000000000000000000111100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000
08800880080800000000000000ffffffd777d777d777d777d77d777d001111111111110000000000000000000000000000000000000000000011111000000000
8788888887888000000000000fffffff726626662666266626626627017777777777771000000000000000000000000000000000000001111133333100000000
878888828888200000000000ffffffff762626662666266626626267177777777777777100000000000000000000000000000000111113333333333100000000
088888200882000000077000ffffffff760000000000000000000067177777777777777100111111111111000000000000011111333333333333333100000000
008882000020000000768700ffffffffd6000000000000000000006d177777777777777101777777777777100000011111133333333333333333333100000000
000220000000000000788700ffffffff720000000000000000000027177777777777777117777777777777710111133333333333333333333333333100000000
000000000000000000077000ffffffff760000000000000000000067177777777777777117777777777777711333333333333333333333333333333100000000
000000000000000000000000ffffffff760000000000000000000067177777777777777117777777777777711333333333333333333333333333333100000000
fffff26dffffffffffffffffffffffffd6000000000000000000006d177777777777777117777777777777711333333333333333333333333333333100000000
fffff222ffffffffffffffffffffffff720000000000000000000027177777777777777117777777777777711333333333333333333333333333332100000000
ffffffffffffffffffffffffffffffff760000000000000000000067177777777777777117777777777777711333333333333333333333333322225100000000
ffffffffffffffffffffffffffffffff760000000000000000000067127777777777772117777777777777711333333333333333333332222255555100000000
ffffffffffffffffffffffffffffffffd6000000000000000000006d1d222222222222d117777777777777711333333333333333222225555555555100000000
ffffffffffffffffffffffffffffffff7200000000000000000000271dddddddddddddd117777777777777711333333333322222555555555555555100000000
fffffffffffff222ffffffff0fffffff7600000000000000000000671dddddddddddddd112777777777777211233332222255555555555555555551100000000
fffffffffffff26dffffffff00ffffff760000000000000000000067d11111111111111dd12222222222221dd122222222222222111111111111111600000000
77777777777777777777777777777767d6000000000000000000006dd62fffffffffffffffffffffffffff000111111000000000000000000000000000000000
77777777777777777777777777777777720000000000000000000027222ffffffffffffffffffffffffffff01777777100000000000000000000000000000000
77777777777777777777777777677777760000000000000000000067ffffffffffffffffffffffffffffffff1777777101111110000000000000000000000000
77777777777777777777777777777777760000000000000000000067ffffffffffffffffffffffffffffffff1777777117777771000000000000000000000000
77777777777777777777777777777777d6000000000000000000006dffffffffffffffffffffffffffffffff1777777117777771000000000000000000000000
77777777776777777777776777777777720000000000000000000027ffffffffffffffffffffffffffffffff1277772117777771000000000000000000000000
77777777767777777677777777777777760000000000000000000067ffffffff222ffffffffffff0ffffffff1222222112777721000000000000000000000000
77777777777777777777777777777777777d777d777d777d777d7777ffffffffd62fffffffffff00ffffffffd111111dd222222d000000000000000000000000
22222222ccc28888ee2e2ee200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000000c0000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000000800000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000000c0000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000000080000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000000c00000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000000080000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000000c0000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
222200008c8c0000e2ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000080000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020000000c0000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000080000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100110000110010010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010880000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10111101880000881002200100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10111101880000880020020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10111101880000880020020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10111101888008881002200100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100008888000010010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01710010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000001100000010000000100000001000000100010000000100000001000000010000000100000000000000000000000000000000000000000000000000000
0000001010000010000000100000011100000100011100100121001001d100100161001001710010000000000000000000000000000000000000000000000000
000001001000010010000000000010111001101111111111121111111d1111d11611116117111171000000000000000000000000000000000000000000000000
00001000110000001000100100010111111101111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
10010000110100101001000101110111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
10000000110000001110001111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
11000000111000011111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
11110000111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccc7ccccccccccccc7cccccccccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc77c7ccccccccccccc7cccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccc77ccccccccccccc7ccccccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccc77cccccccccccc7cccccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccc7c77cccccccccc7ccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccc7c7ccccccccccc7cccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccc7c7ccccccccccc7ccccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccc7c7cccccccccccc7cccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccc7c7ccccccccccc7ccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccc7c7ccccccccccc7ccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccc777ccccccccccc7cccccccccccccc77ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccc7cc777cccccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccc7cccc77cccccc7cccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccc7ccccc7cccccc7cccccccccccc77ccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccc7cccccccccccccccc7cccc7ccccccc7ccccccccc77ccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccc7cccccccccccccccc7777cc7cccccc7ccccccc77ccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccc7ccccccccccccccccdcc77777cc77cccccc77ccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccc
ccccccccccccccccccccccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccc
ccccccccccccccccccccccc1177777711117777117777771177777711777777117777771177777711771177117777771177777711ccccccccccccccccccccccc
ccccccccccccccccccddddd1177777711117777117777771177777711777777117777771177777711771177117777771177777711ccccccccccccccccccccccc
cccccccccccccdddddccccc1111771111771111117711111177117711771177117711111177117711771177117711111177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1111771111771111117711111177117711771177117711111177117711771177117711111177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1111771111771111117777111177771111777711117777111177777711777711117777111177771111ccccccccccccccccccccccc
ccccccccccccccccccccccc1111771111771111117777111177771111777711117777111177777711777711117777111177771111ccccccccccccccccccccccc
ccccccccccccccccccccccc1111771111771111117711111177117711771177117711111177117711771177117711111177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1111771111771111117711111177117711771177117711111177117711771177117711111177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1177777711117777117777771177777711771177117777771177117711771177117777771177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1177777711117777117777771177777711771177117777771177117711771177117777771177117711ccccccccccccccccccccccc
ccccccccccccccccccccccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccc
ccccccccccccccccccccccc1111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddd7c7ccccccc7cddcccc7d7ccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccddcdddcdcd7c7ccccccc7cccdddcc7ddddddddddcccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccc7dcd7dcdccd7cc7ccccccc7ccccdcc77ccccccccdcccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccc7dcdcdcccdc7cc7ccccccc7ccccdccc7cccccccccdccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccc7cd7cdccccdc7cc7ccccccc77cccdccc777777777cdccc7ccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccd7cdcccdcc7ccc7cccccccc777dccc7cccccccc7d777cccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccd7ccdcccdcc7ccc7cccccccccccd7777ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccd7ccdccdccc7ccc7cccccccccccdccc77cccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccd7ccddccdccc7ccc7cccccccccccdccc7ccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccdcccddcdcccc7ccc7cccccccccccddcc7ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccdccccddcdccccc7cc7cccccccccccccddddcccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccdcccdcddcccccc7cc7cccccccccccccccc7dddccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccdccccdcdcccccccc7cccccccccccccccccc7cccddccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccdccccdccdccccccccc7cccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccdccddccccdcccccccc7cccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccdccdccccccdccccccccc7ccccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccdcdccccccccdccccccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccdccdccccccccdccccccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccdccdccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccdccdccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccdcdcccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccddccdcccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccdcccddcccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccddccddcccccccdddddcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccdcccdcccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccdccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccdcccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccddccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccdccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccdcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

__map__
5455555555555555555555555555555654555555555555555555555555555556545555555555555555555555555555560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000005360777a00000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000006262626200000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000006262626200000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000006361787900000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6400000000000000000000000000006664000000000000000000000000000066640000000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7475757575757575757575757575757674757575757575757575757575757576747575757575757575757575757575760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
150900000f4131e623004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403
000d00001874518705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705
310400001f5731e5731b5731c56318543175230f51309513005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050000500
010400001474313743117430f7430c7430c7430000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
0507000011153105530c1330c1230c1130c1130050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503
010900003003532055320353202500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500000000000000000000
000200000f5200c530085402600000005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
010c00001715317023000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000000000
4903000011710117101172011730117401175012750167401a7301670000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
3104000013573125730f573105630c5430b5230351309513005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050000500
010a00001905423054180030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300000
010800001a3431a313002030020300203002030020300203002030020300203002030020300203002030020300200002000020000200002000020000200002000020000200000000000000000000000000000000
00060000147341f744237540000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400000
011700000e77400704007040070400704007040070400704007040070400704007040070400704007040070400704007040070400704007040070400704007040070400704007040070400704007040070400000
010900002407424074240740000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004
010f00000f35305633036130000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
010200000c15300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300100
00060000121540b154001040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004
000200001215300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300103001030010300100
000100000f55313553005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503
030400000860400604006040060400604006040060400604006040060400604006040060400604006040060400604006040060400604006040000000000000000000000000000000000000000000000000000000
