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
#include lib.lua
__gfx__
00000000000dd00000c0000022222222000dd222000000000880088000f000000066600000000000000000000000000000000000000000000000000000000000
00000000000dd0000ccc00c000020000000dd02000000000878888880fff00f000dddd6000000000000000000000000000000000000000000000000000000000
0070070000dddd00cccccccc0002000000dddd200000000087888888ffffffff6dd666d000000000000000000000000000000000000000000000000000000000
000770000dddddd0cccccccc000200000ddddd200000000088888888ffffffff6d6dd6d600000000000000000000000000000000000000000000000000000000
00077000000dd000cccccccc00020000000dd0200000000088888882ffffffff0d6dd6d600000000000000000000000000000000000000000000000000000000
00700700000dd000cccccccc00020000000dd0200000000008888820ffffffff0666ddd000000000000000000000000000000000000000000000000000000000
0000000000d00d00cccccccc0002000000d00d200000000000888200ffffffff0ddddd6000000000000000000000000000000000000000000000000000000000
000000000d0000d0cccccccc000200000d0000d00000000000022000ffffffff0066dd0000000000000000000000000000000000000000000000000000000000
00000000000000000090000000800000000000000000000008080000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000999009008880080000000000000000087888000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000088882000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000008820000000770000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000000200000007687000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000000000000007887000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000000000000000770000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999988888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666660000060000066660000666600000060000066666000666660066666000066660000666600000000000000000000000000000000000000000000000000
006ddd600006600006dddd6006dddd600006600006ddddd006ddddd00ddddd6006dddd6006dddd60000000000000000000000000000000000000000000000000
06d00060006d60000d0000600d000060006d60000600000006000000000000600600006006000060000000000600060000000000000000000000000000000000
0600006000d06000000006d00006660006d060000d66660006666600000006d0006666000d666660000000000d606d0000000000000000000000000000000000
060000600000600000066d00000ddd600666666000dddd6006dddd600000060006dddd6000dddd600000000000d6d00000000000000000000000000000000000
060006d000006000006dd000060000600ddd6dd0000000600600006000000600060000600000006006600000006d600000000000000000000000000000000000
0666660000666600066666600d6666d000006000066666d00d6666d000006d000d6666d0066666d00660000006d0d60000000000000000000000000000000000
0ddddd0000dddd000dddddd000dddd000000d0000ddddd0000dddd000000d00000dddd000ddddd000dd000000d000d0000000000000000000000000000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111
111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111
111cc111111cccc1111cc111111cc111111cc111111cc111111cc111111cc11cc11cc111111cc111111cccccccccc1111cccc111111cc111111cccc1111cc111
111cc111111cccc1111cc111111cc111111cc111111cc111111cc111111cc11cc11cc111111cc111111cccccccccc1111cccc111111cc111111cccc1111cc111
111cccc11cccc11cccccc11cccccc11cc11cc11cc11cc11cccccc11cc11cc11cc11cc11cccccc11cc11cccccccccc11cc11cc11cccccc111111cc11cc11cc111
111cccc11cccc11cccccc11cccccc11cc11cc11cc11cc11cccccc11cc11cc11cc11cc11cccccc11cc11cccccccccc11cc11cc11cccccc111111cc11cc11cc111
111cccc11cccc11cccccc1111cccc1111cccc1111cccc1111cccc111111cc1111cccc1111cccc1111cccccccccccc11cc11cc1111cccc11cc11cc11cc11cc111
111cccc11cccc11cccccc1111cccc1111cccc1111cccc1111cccc111111cc1111cccc1111cccc1111cccccccccccc11cc11cc1111cccc11cc11cc11cc11cc111
111cccc11cccc11cccccc11cccccc11cc11cc11cc11cc11cccccc11cc11cc11cc11cc11cccccc11cc11cccccccccc11cc11cc11cccccc11cc11cc11cc11cc111
111cccc11cccc11cccccc11cccccc11cc11cc11cc11cc11cccccc11cc11cc11cc11cc11cccccc11cc11cccccccccc11cc11cc11cccccc11cc11cc11cc11cc111
111cc111111cccc1111cc111111cc111111cc11cc11cc111111cc11cc11cc11cc11cc111111cc11cc11cccccccccc111111cc111111cc11cc11cc1111cccc111
111cc111111cccc1111cc111111cc111111cc11cc11cc111111cc11cc11cc11cc11cc111111cc11cc11cccccccccc111111cc111111cc11cc11cc1111cccc111
111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111
111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111171111171711111111111111111111111111111117777711111177111111111111111111111111111777771111111111111111111111111111111111
11111111117111171711771777177717771771117111111177711771111171711771771177711771711111117711777111111111111111111111111111111111
11111777111711177717171777177717711717111111111177111771111171717171717177717171711111117711177111111111111111111111111111111111
11111111117111171717771717171717111771117111111177711771111171717171771171717771711111117711777111111111111111111111111111111111
11111111171111171717171717171711771717111111111117777711111171717711717171717171177111111777771111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111177711111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111117117171777111111771711117711771177177711771111111111111111111111111111111111111
11111111111111111111111111111111111111111111111117117171771111117111711171717111711117117111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111117117771711111117111711177711171117117117111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111117117171177111111771177171717711771177711771111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111ccc1111111111111111111111111111111ccccc111111cc1111111111111111111ccccc111111111111111111111111111111111111111111
111111111111111ccc11cc1cc111c1111111111111111111ccc11cc11111c1c11cc1cc11ccc11111cc11ccc11111111111111111111111111111111111111111
111111111111111c1c1c1c1c1c1111111111111111111111cc111cc11111c1c1c1c1c1c1cc111111cc111cc11111111111111111111111111111111111111111
111111111111111c1c1c1c1c1c11c1111111111111111111ccc11cc11111c1c1c1c1c1c1c1111111cc11ccc11111111111111111111111111111111111111111
111111111111111c1c1cc11cc111111111111111111111111ccccc111111c1c1cc11c1c11cc111111ccccc111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111b1b11111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111b1b11bb1bb11bbb1b111b1111bb111111bb1b1111bb1b1b111111111111111111111111111111111
111111111111111111111111111111111111111111111111b1b1b1b1b1b11b11b111b111b1b11111b1b1b111b1b1bbb111111111111111111111111111111111
111111111111111111111111111111111111111111111111bbb1bbb1b1b11b11b111b111bbb11111bbb1b111bbb111b111111111111111111111111111111111
1111111111111111111111111111111111111111111111111b11b1b1b1b1bbb11bb11bb1b1b11111b1111bb1b1b1bb1111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111188111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111181811881111118818881881181811881111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111181818181111181818811818188118111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111181818181111188818111881181811181111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111181818811111181111881818181818811111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111ccccc111111ccc11cc111111cc1ccc1ccc1ccc1ccc1111111111111111111111111111111111111111111111111111111111111111111111
111111111111111cc1c1cc111111c11c1c11111c1111c11c1c1c1c11c11111111111111111111111111111111111111111111111111111111111111111111111
111111111111111ccc1ccc111111c11c1c11111ccc11c11ccc1cc111c11111111111111111111111111111111111111111111111111111111111111111111111
111111111111111cc1c1cc111111c11c1c1111111c11c11c1c1c1c11c11111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111ccccc1111111c11cc111111cc111c11c1c1c1c11c11111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111161616661166161611111166116611661666166611111111166116161666166616661661111111111111111111111111111111111111111111
11111111111111161611611611161611111611161116161616161111611111116116161116161616161161111111111111111111111111111111111111111111
11111111111111166611611611166611111666161116161661166111111111116116661116161616161161111111111111111111111111111111111111111111
11111111111111161611611616161611111116161116161616161111611111116111161116161616161161111111111111111111111111111111111111111111
11111111111111161616661666161611111661116616611616166611111111166611161116166616661666111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111166616661166166611111166116616661666116611111111166616661111111111111111111111111111111111111111111111111111111111
11111111111111161616111611116111111611161616661616161611611111161611161111111111111111111111111111111111111111111111111111111111
11111111111111166116611666116111111611161616161661161611111111166611661111111111111111111111111111111111111111111111111111111111
11111111111111161616111116116111111611161616161616161611611111161611161111111111111111111111111111111111111111111111111111111111
11111111111111166616661661116111111166166116161666166111111111166616661111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__sfx__
150900000f4131e623004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403004030040300403
010c00001755720557235072450700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507005070050700507000070000700007
310400001f5731e5731b5731c56318543175230f51309513005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050000500
010400001474313743117430f7430c7430c7430000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
0507000011153105530c1330c1230c1130c1130050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503
010900003003532055320353202500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500000000000000000000
010800002400026000260002600000005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
