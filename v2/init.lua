function _init()
    _g=_ENV

    debug_arena=false

    shake_enabled,sh_str=true,0

    continue,global_cnt,anim_cnt,trans_cntr=0,0,0,-1

    o_hold,x_hold=false,false

    menu_lvl,selected,confirm,page_detail=1,{1,1,1},0,false
    expand_page_x,expand_page_y,expand_page_yt=0,0,0
    stamp_cntr=-1

    menu_txt=split"\#c\f1campaign\n\|h\-k\#7\f6ENDLESS\n\|h\-kOPTIONS,\#7\f6CAMPAIGN\n\|h\-k\#c\f1endless\n\|h\-k\#7\f6OPTIONS,\#7\f6CAMPAIGN\n\-kENDLESS\n\|h\-k\#c\f1options"

    levels={
        {"\f1tRAINING","wELCOME, NEW\nRECRUIT!\n\nlEARN THE BASICS\nIN THIS FIELD\nTRAINING MISSION."},
        {"\f1fIRST cONTACT","tHIS IS YOUR\nFIRST OFFICIAL\nDEPLOYMENT.\n\npREPARE TO FACE\nOFF AGAINST YOUR\nICE ENEMIES!"},
        {"\f1eRIF rESCUE",""},
        {"\f1mOUNTAINS",""},
        {"\f1iCE pEAK",""},
        {"\f1cOLD bLAST",""},
        {"\f1fACTORY sHUTDOWN",""}
    }

    -- level,wave -> concurrent,normal,fast,projectile
    lvl_data={
        {{0,0}},
        {{10,1,0,0},{100,200,200,0}}
    }

    --117 tokens!
    settings_options={
        {
            56,64,
            "button swap",
            "sWAP THE USES OF ❎ AND\n🅾️.",
            false,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
        {
            56,72,
            "screen shake",
            "tOGGLE SCREEN SHAKE\nTHROUGHOUT THE GAME.",
            true,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
        {
            56,80,
            "camera movement",
            "tOGGLE CAMERA MOVEMENT\nDURING GAMEPLAY.",
            true,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
        {
            56,88,
            "unlock combat accessibility",
            "eNABLE ACCESS TO FEATURES\nWHICH MAKE COMBAT MORE\nACCESSIBLE.\n\n\f0alters gameplay\nsignificantly.",
            true,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
        {
            40,72,
            "gameplay speed",
            "dECREASE GAMEPLAY SPEED.",
            true,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
        {
            40,64,
            "invincibility",
            "tAKE NO DAMAGE DURING\nGAMEPLAY.",
            true,
            toggle=function(self)
                self[2]=not self[2]
            end
        },
    }

    splash,menu,page,tutorial,play,heli,stats=false,true,2,false,false,false,false

    p_spawned=false
    p_roll_cntr,p_inv_cntr,p_combo_cntr,pfp_cntr,outro_cntr,sb_cntr,sb_auto_cntr=-1,-1,-1,-1,-1,-1,-1,-1
    c_x,c_y,c_x_target,c_y_target,page_y=0,0,0,0,0

    drawer_x,drawer_x_target=split"0.5,0",split"0,0"

    --[[
    -- start frame, length, speed multiplier
    anims = {
        {1,4,0.3},  -- player idle
        {17,5,0.4}, -- player run
        {33,2,0.1}, -- player idle (w/ hammer)
        {49,4,0.3}, -- player run (w/ hammer)
        {6,5,0.45}, -- player roll

        {129,3,1}, -- hammer spin
    }
    ]]

    anims=split"1;4;0.3,17;5;0.4,33;2;0.1,49;4;0.3,6;5;0.45,129;3;1"
    --start frame,len,multi
    --p-idle,p-run,p-idleh,p-runh,p-roll,h-spin
    oval_anim=split"-10;-10;-10;-10,14;-5;16;35,-10;13;40;17,-2;5;32;25,0;0;30;30"
    for i=1,6 do
        if (i<6) oval_anim[i]=split(oval_anim[i],";")
        anims[i]=split(anims[i],";")
    end

    sb_current,big_combo_print=1,0
    
    particles,dwash_cnt,hearts={},0,{}

    --dialogue
    d_compress = {
        -- 1: tutorial
        "\f1attention!!\n\n\fdtHIS IS \f9cOLONEL\nmAX\fd CALLING.%\fdi'M HERE TO GUIDE\nYOU THROUGH THE\n\f9BASICS OF COMBAT\fd.%\fdlET'S GET TO IT!%\fduSE \f9⬆️⬇️⬅️➡️\fd TO\nMOVE AROUND THE\nBATTLEFIELD.%\fdtO THE RIGHT IS\nA SERVICE WEAPON,\n\f9THE hammer.\n\fdpICK IT UP!%\fdtHROW WITH\n\f9⬆️⬇️⬅️➡️\fd AND \f9🅾️\fd,\nTHEN PICK IT UP\nAGAIN.%\fdgREAT!\ntHROW THE HAMMER\nAT ENEMIES TO\n\f9DESTROY\fd THEM.%\fdaMAZING! lET ME\nEXPLAIN THESE\n\f9STATS\fd YOU CAN\nSEE.%\fdtHERE'S YOUR\n\f9HEALTH VIAL \fdAT\nTHE TOP; 3 HITS\nAND YOU'RE DOWN.%\fdtHE \f3NUMBER\fd'S YOUR\n\f9SCORE\fd; WE TRACK\nIT FOR METRICS\nAND EVALUATIONS.%\fdaT THE BOTTOM IS\nYOUR \f9COMBO\fd.\nKILL ENEMIES TO\nINCREASE IT!%\fdyOU GET HIGHER\nSCORES IF YOU\nHAVE A HIGHER\nCOMBO.%\fdbUT YOU LOSE IT\nIF YOU DON'T KILL\nENEMIES \f9QUICKLY\fd,\nOR IF YOU'RE \f9HIT\fd.%\fdoK! fINALLY,\n\f9⬆️⬇️⬅️➡️\fd AND \f9❎\fd\nWHILE EMPTY-\nHANDED \f9TO ROLL\fd.%\fdwITH \f9GOOD TIMING\fd,\nYOU CAN ROLL\nTHROUGH ENEMIES\n\f9TAKING NO DAMAGE\fd.%\fdtAKE AS MUCH TIME\nAS YOU NEED TO\nPRACTICE THESE\nSKILLS.%\fdwHEN YOU'RE READY\nTO LEAVE, HEAD TO\nTHE \f8EVAC ZONE\fd.\ngOOD LUCK!",
        
        -- 2: first contact
        "yOU'RE HEADED TO\nTHE OUTSKIRTS OF\nTHE FRONT LINE.%oUR READINGS\nINDICATE MINIMAL\nENEMY ACTVIVTY,%SO IT'S A GREAT\nPLACE TO TRY YOUR\nHAND AT REAL\nCOMBAT.%gOOD LUCK,\nRECRUIT!%tHAT WAS SOME\nGREAT WORK,\nRECRUIT.%lET'S HEAD BACK\nTO BASE.",
        
        -- 3: erif rescue
        "gOOD JOB ON THAT\nFIRST MISSION!%yOU'RE HEADED TO\nTHE EVACUATED\nVILLAGE OF \f9eRIF\fd.%iT'S BECOME A\n\f9STRONGHOLD\fd ALONG\nTHE FRONT LINE...%YOUR JOB IS TO\n\f9PROTECT IT\fd.%eRIF IS SAFE,\nTHANKS TO YOU.%yOUR SKILLS HAVE\nIMPROVED GREATLY!",
        
        -- 4: mountains
        "wE'RE HEADED TO\n\f9THE MOUNTAINS\fd;\nTHIS IS \f8ENEMY\nTERRITORY\fd.%wE'VE HEARD\nREPORTS OF \f9ICY\nCONDITIONS\fd...%WHICH MIGHT POSE\nSOME ISSUES.%wE'RE PUTTING OUR\nFAITH IN YOUR\nSKILLS. \f9SHOW THEM\nWHO'S BOSS\fd!%yOU HANDLED THAT\nICE PERFECTLY.%i, FOR ONE, WAS\nSLIGHTLY WORRIED,\nBUT YOU DID\nGREAT!",

        -- 5: ice peak
        "yOUR NEXT MISSION\nIS IN \f9ICE PEAK\fd,\nAN \f8ENEMY\nSTRONGHOLD\fd.%wE'VE FOUND \f9ENEMY\nWATER RESERVES\fd;\nTHE \f9SOURCE\fd OF\nTHEIR ICE ARMY.%tO ASSIST, OUR\nSCIENTISTS HAVE\n\f9SCATTERED HEALING\nSUPPLIES THERE\fd.%sO YOU SHOULD SEE\nSUPPLIES \f9INSIDE\fd\nYOUR FROZEN\nENEMIES!%tHE LAB IS \f9OVER\nTHE MOON\fd! EXPECT\nMORE SUPPLIES IN\nTHE FUTURE.%sEEMS YOU'LL NEED\nIT; METEOROLOGY\nSAY A \f9STORM'S\nBREWING...",
    }

    d={}
    for lvl_d in all(d_compress) do
        add(d, split(lvl_d, '%'))
    end

    if debug_arena then
        menu,play,selected,sb_current=false,true,2,5
        initialise_game()
        heli,intro,p_spawned,c_x_target,c_y_target,p_x,p_y,h_x,h_y,h_hide=false,false,true,58,48,50,50,70,50,false
        fc=0
    end
end

function initialise_menu(p)
    menu,play,tutorial,stats,heli,page,sb_current,sb_cntr,p_spawned,pfp_cntr,shown,heli,c_x,c_y,outro_cntr,page_y,top_drawer_max_x=
    true,false,false,false,false,p,
    1,-1, --sb:curr,cntr
    false,-1, --p-spawn,pfp-cntr
    false,false, --shown,heli
    1000,0,-1,0, --cxy,outro-cntr,py
    12*#levels+20
end

function initialise_game()
    lvl=lvl_data[lvl_id]
    wave,wave_cnt,bound_xl,bound_xu,bound_yl,bound_yu,c_x_target,c_y_target,p_spawned,p_x,p_y,p_move_speed,p_roll_cntr,p_anim,p_flip,p_health,p_inv_cntr,p_score1,p_score2,p_combo,p_combo_cntr,h_type,h_x,h_y,h_xw,h_yw,h_v,h_mag_v,h_dir,h_h,h_flip,h_held,kickback_dir,es,proj_buffer=
    0,#lvl,
    3,117,tutorial and 61 or 2,115,-90,20, --boundxy x2,cxt,cyt
    false,-103,50,1.4, --p:spawned,x,y,speed
    -1,1,false,3,-1,    --  roll-cntr,anim,flip,health,inv-cntr
    0,0,0,-1,           --  score1+2,combo,combo-cntr
    2,60,60,10,8, --h:type,x-y-xw-yw
    0,0,{0,0},0,false, --v,mag-v,dir,height,flip,held
    0,{} --kickback-dir,es,proj-buffer

    increment_wave()

    e_spawn_interval,e_spawn_timer,heli,pickup,outro_cntr,heli_x,heli_y,heli_x_target,heli_y_target,intro,intro_phase,p_dropping,h_dropping,particles,dwash_cnt=
    15,0, --e-spawn:interval,timer
    true,false,-1, --heli,pickup,outro-cntr
    -120,0,-120,0, --heli:x,y,xt,yt
    true,1,false,false, --intro,phase,p-drop,h-drop
    {},0 --particles,dwash-cnt

    start_pfp()
end

function initialise_tutorial()
    initialise_game()

    tutorial,t_rolled,t_thrown,heli,intro,outro,p_x,p_y,h_x,h_y,c_x_target,c_y_target=
    true,false,false,
    false,false,false, --heli,intro,outro
    40,90,100,90,72,48 --px,py,hx,hy,cxt,cyt
    
    start_pfp()

    sb_current,sb_cntr,sb_wait,sb_auto_cntr=
    1,-1, -- which line?,sb-cntr
    false,-1 -- waiting for button input,auto skip
end

function start_pfp()
    pfp_cntr,pfp_x,pfp_y,pfp_w=-1,8,22,30
end

function btnh(b)
    if (b==4 and not o_hold and btn"4") o_hold=true return true
    if (b==5 and not x_hold and btn"5") x_hold=true return true
    return false
end