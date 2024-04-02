function _init()
    _g=_ENV
    throw_btn=4
    roll_btn=5

    debug_arena=false

    shake_enabled,sh_str,cam_enabled,acc_lock,game_speed,invincible=true,0,true,true,1,false

    continue,global_cnt,anim_cnt,trans_cntr=0,0,0,-1

    throw_hold,roll_hold=false,false

    menu_lvl,selected,confirm,page_detail=1,{1,1,1},0,false
    expand_page_x,expand_page_y,expand_page_yt=0,0,0
    stamp_cntr=-1

    menu_txt=split"\f1campaign\n\|h\-k\f6ENDLESS\n\|h\-kOPTIONS,\f6CAMPAIGN\n\|h\-k\f1endless\n\|h\-k\f6OPTIONS,\f6CAMPAIGN\n\-kENDLESS\n\|h\-k\f1options" --\#c

    levels={
        {"\f1fIRST cONTACT","wELCOME, NEW\nRECRUIT!\n\nlEARN THE BASICS\nIN THIS FIELD\nTRAINING MISSION."},
        {"\f1oPEN rANGE","aPPLY THE BASIC\nLESSONS IN YOUR\nFIRST OFFICIAL\nDEPLOYMENT."},
        {"\f1oN A rOLL","lEARN THE COMBAT\nROLL, A VITAL\nASPECT OF\nBATTLEFIELD\nSURVIVAL."},
        {"\f1eRIF rESCUE","tHIS IS YOUR\nFIRST OFFICIAL\nDEPLOYMENT.\n\npREPARE TO FACE\nOFF AGAINST YOUR\nICE ENEMIES!"},
        {"\f1mOUNTAINS",""},
        {"\f1iCE pEAK",""},
        {"\f1cOLD bLAST",""},
        {"\f1fACTORY sHUTDOWN",""},
    }

    -- level,wave -> concurrent,normal,fast,projectile
    lvl_data={
        {{1,5,0,0},{1,5,0,0},{1,10,0,0}},
        {{1,1,0,0},{1,15,0,0},{2,15,0,0}},
        {{1,1,0,0},{1,10,0,0},{2,10,0,0}},
    }

    refresh_settings()

    splash,menu,page,play,heli,stats,dpause=false,true,2,false,false,false,false

    p_spawned=false
    p_roll_cntr,p_inv_cntr,p_combo_cntr,pfp_cntr,outro_cntr,sb_cntr,sb_auto_cntr,checkm_cntr,roll_check_cntr,wbanner_cntr=-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
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

    sb_current,big_combo_print,sb_mode=1,0,1
    tt_move1,tt_move2,tt_move3,tt_held,tt_thrown,tt_roll,tt_roll_pass=false,false,false,false,false,false
    
    particles,dwash_cnt,hearts={},0,{}

    --dialogue
    d_compress = {
        -- 1: first contact
        "\f1attention!!%\fdtHIS IS \f9cOLONEL\nmAX\fd CALLING.%\fdi'M HERE TO\nGUIDE YOU IN THE\n\f9BASICS OF COMBAT\fd.%\fdlET'S GET TO IT!%3%\f9wELCOME TO THE\nBATTLEFIELD\fd! tRY\nMOVING AROUND.%2%mOVE TO THE MARKERS AROUND\nTHE BATTLEFIELD.%1%nICE! nOW TRY\nYOUR SERVICE\nWEAPON, THE\n\f9hammer\fd.%2%\|kpICK UP THE HAMMER.%tHROW BY HOLDING A\nDIRECTION AND PRESSING "..(throw_btn==4 and "🅾️" or "❎")..".%1%aMAZING! \f9tHROW\nTHE HAMMER AT\nENEMIES \fdTO KILL\nTHEM!%2%\|kkILL 5 eNEMIES.%1%iNCREDIBLE!\nhERE COME THE\nREST; \f9APPLY\nYOUR SKILLS\fd!%3%tHAT WAS SOME\n\f9GREAT WORK\fd,\nRECRUIT.%lET'S HEAD BACK\nTO BASE.",
        
        "yOU'RE HEADED TO\nTHE OUTSKIRTS OF\nTHE FRONT LINE.%oUR READINGS\nINDICATE MINIMAL\nENEMY ACTVIVTY,%SO IT'S A GREAT\nPLACE TO TRY\nYOUR HAND AT\nREAL COMBAT.%gOOD LUCK,\nRECRUIT!%3%gREAT WORK!\nyOU'RE BUILDING\nYOUR SKILLS\nQUICKLY!",
        
        "gOOD JOB ON\nTHOSE FIRST TWO\nMISSIONS,\nRECRUIT.%nEXT, WE NEED TO\nGO OVER ANOTHER\nCOMBAT ESSENTIAL.%3%tODAY, WE'RE\nLEARNING THE\n\f9roll\fd.%wHEN YOU'RE\n\f9SURROUNDED\fd BY\nENEMIES...%OR YOU NEED TO\n\f9REPOSITION\fd,\nROLLING IS\nYOUR BEST BET.%tRY IT OUT!%2%wHILE NOT HOLDING THE HAMMER,\nHOLD A DIR + PRESS "..(roll_btn==5 and "❎" or "🅾️").." TO ROLL.%1%nOTICE HOW \f9YOU\nCAN'T ROLL WHILE\nHOLDING THE\nHAMMER\fd?%yOU'LL HAVE TO\nTHROW IT TO ROLL,\nAND \f9RETRIEVE IT\nLATER\fd.%\f9hOWEVER\fd!%yOU'RE FULLY\nINVINCIBLE FOR\nA SPLIT SECOND\nWHILE ROLLING.%\f9uSE IT TO YOUR\nADVANTAGE\fd!%2%rOLL THROUGH THE ENEMY\nWITHOUT TAKING DAMAGE.%1%yOU GOT IT!%rOLLING IS\nESSENTIAL TO\nDEFEATING YOUR\nENEMIES.%mAKE SURE TO\n\f9MASTER THE\nTIMING\fd!%\f9oH\fd - HERE COME\nMORE! lET'S SEE\nYOUR ROLLING\nSKILLS!%3%tHAT WAS\nINCREDIBLE!\nlET'S HEAD BACK.",

        -- 3: erif rescue
        "gOOD JOB ON THAT\nFIRST MISSION!%yOU'RE HEADED TO\nTHE EVACUATED\nVILLAGE OF \f9eRIF\fd.%iT'S BECOME A\n\f9STRONGHOLD\fd ALONG\nTHE FRONT LINE...%YOUR JOB IS TO\n\f9PROTECT IT\fd.%eRIF IS SAFE,\nTHANKS TO YOU.%yOUR SKILLS HAVE\nIMPROVED GREATLY!",
        
        -- 4: mountains
        "wE'RE HEADED TO\n\f9THE MOUNTAINS\fd;\nTHIS IS \f8ENEMY\nTERRITORY\fd.%wE'VE HEARD\nREPORTS OF \f9ICY\nCONDITIONS\fd...%WHICH MIGHT POSE\nSOME ISSUES.%wE'RE PUTTING OUR\nFAITH IN YOUR\nSKILLS. \f9SHOW THEM\nWHO'S BOSS\fd!%yOU HANDLED THAT\nICE PERFECTLY.%i, FOR ONE, WAS\nSLIGHTLY WORRIED,\nBUT YOU DID\nGREAT!",

        -- 5: ice peak
        "yOUR NEXT MISSION\nIS IN \f9ICE PEAK\fd,\nAN \f8ENEMY\nSTRONGHOLD\fd.%wE'VE FOUND \f9ENEMY\nWATER RESERVES\fd;\nTHE \f9SOURCE\fd OF\nTHEIR ICE ARMY.%tO ASSIST, OUR\nSCIENTISTS HAVE\n\f9SCATTERED HEALING\nSUPPLIES THERE\fd.%sO YOU SHOULD SEE\nSUPPLIES \f9INSIDE\fd\nYOUR FROZEN\nENEMIES!%tHE LAB IS \f9OVER\nTHE MOON\fd! EXPECT\nMORE SUPPLIES IN\nTHE FUTURE.%sEEMS YOU'LL NEED\nIT; METEOROLOGY\nSAY A \f9STORM'S\nBREWING...",
    }

    d={}
    for lvl_d in all(d_compress) do
        add(d, split(lvl_d,'%',false))
    end

    initialise_menu(2)

    if debug_arena then
        menu,play,selected,sb_current=false,true,2,5
        initialise_game()
        heli,intro,p_spawned,c_x_target,c_y_target,p_x,p_y,h_x,h_y,h_hide=false,false,true,58,48,50,50,70,50,false
        fc=0
    end
end

function initialise_menu(p)
    menu,play,stats,heli,page,sb_current,sb_cntr,p_spawned,pfp_cntr,shown,heli,c_x,c_y,outro_cntr,page_y,page_detail,expand_page_yt,top_drawer_max_x=
    true,false,false,false,p,
    1,-1, --sb:curr,cntr
    false,-1, --p-spawn,pfp-cntr
    false,false, --shown,heli
    5000,0,-1,0,false,0, --cxy,outro-cntr,page:y,detail,expand-y
    12*#levels+20
end

function initialise_game()
    lvl=lvl_data[lvl_id]
    tutorial,wave,wave_cnt,bound_xl,bound_xu,bound_yl,bound_yu,c_x_target,c_y_target,p_spawned,p_x,p_y,p_move_speed,p_roll_cntr,p_anim,p_flip,p_health,p_inv_cntr,p_score1,p_score2,p_combo,p_combo_cntr,h_type,h_x,h_y,h_xw,h_yw,h_v,h_mag_v,h_dir,h_h,h_flip,h_held,kickback_dir,es,proj_buffer=
    is_in(lvl_id,{1,3}),0,#lvl,
    3,117,2,115,-90,20, --boundxy x2,cxt,cyt
    false,-103,50,1.4, --p:spawned,x,y,speed
    -1,1,false,3,-1,    --  roll-cntr,anim,flip,health,inv-cntr
    0,0,0,-1,           --  score1+2,combo,combo-cntr
    1,60,60,10,8, --h:type,x-y-xw-yw
    0,0,{0,0},0,false,false, --v,mag-v,dir,height,flip,held
    0,{},{} --kickback-dir,es,proj-buffer

    increment_wave()

    e_spawn_interval,e_spawn_timer,heli,pickup,outro_cntr,heli_x,heli_y,heli_x_target,heli_y_target,intro,intro_phase,p_dropping,h_dropping,particles,dwash_cnt=
    15,0, --e-spawn:interval,timer
    true,false,-1, --heli,pickup,outro-cntr
    -120,0,-120,0, --heli:x,y,xt,yt
    true,1,false,false, --intro,phase,p-drop,h-drop
    {},0 --particles,dwash-cnt

    start_pfp()
end

function start_pfp()
    pfp_cntr,pfp_x,pfp_y,pfp_w=-1,8,22,30
end

function btnh(b)
    local b=tostr(b)
    if (b=="4" and not throw_hold and btn"4") throw_hold=true return true
    if (b=="5" and not roll_hold and btn"5") roll_hold=true return true
    return false
end

function refresh_settings()
    settings_options={
        {
            throw_btn==4 and 56 or 64,64,
            "button swap",
            "sWAP THE USES OF ❎ AND\n🅾️ DURING GAMEPLAY.\n\|kcURRENTLY:\n"..(throw_btn==5 and "❎" or "🅾️").."\-hthrow  "..(roll_btn==4 and "🅾️" or "❎").."\-hroll",
        },
        {
            shake_enabled and 56 or 64,72,
            "screen shake",
            "tOGGLE SCREEN SHAKE\nTHROUGHOUT THE MENU AND\nGAME.",
            shake_enabled
        },
        {
            cam_enabled and 56 or 64,80,
            "camera movement",
            "tOGGLE CAMERA MOVEMENT\nDURING GAMEPLAY.",
            cam_enabled
        },
        {
            acc_lock and 56 or 64,88,
            "combat accessibility",
            "aCCESS FEATURES WHICH\nMAKE COMBAT MORE\nACCESSIBLE.\n\|i\^#\f7alters gameplay\nsignificantly.",
            not acc_lock
        },
        {
            acc_lock and 48 or 40,64,
            "half speed",
            "hALVE THE GAMEPLAY\nSPEED.",
            game_speed==0.5
        },
        {
            acc_lock and 88 or invincible and 80 or 72,64,
            "invincibility",
            "tAKE NO DAMAGE DURING\nGAMEPLAY.",
            invincible
        },
    }
end