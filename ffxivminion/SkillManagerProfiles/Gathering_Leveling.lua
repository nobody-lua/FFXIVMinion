-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["filters"] = {
		[1] = "";
		[2] = "";
		[3] = "";
		[4] = "";
		[5] = "";
	};
	["skills"] = {
		[1] = {
			["chainend"] = "0";
			["chainname"] = "";
			["chainstart"] = "0";
			["charge"] = "0";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "In Combat";
			["comboskill"] = "Auto";
			["dobuff"] = "0";
			["doprev"] = "0";
			["enmityaoe"] = "0";
			["filterfive"] = "Ignore";
			["filterfour"] = "Ignore";
			["filterone"] = "Ignore";
			["filterthree"] = "Ignore";
			["filtertwo"] = "Ignore";
			["frontalconeaoe"] = "0";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "Auto";
			["gcdtime"] = 0.5;
			["gcdtimelt"] = 2.5;
			["gpbuff"] = "";
			["gpmax"] = 0;
			["gpmin"] = 0;
			["gpnbuff"] = "";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "None";
			["hprio2"] = "None";
			["hprio3"] = "None";
			["hprio4"] = "None";
			["hpriohp"] = 0;
			["id"] = 227;
			["ignoremoving"] = "0";
			["isunspoiled"] = "0";
			["itemchancemax"] = 0;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["levelmax"] = 0;
			["levelmin"] = 0;
			["m10actionid"] = 0;
			["m10actionmsg"] = "";
			["m10actiontarget"] = "Target";
			["m10actionwait"] = 100;
			["m11actionid"] = 0;
			["m11actionmsg"] = "";
			["m11actiontarget"] = "Target";
			["m11actionwait"] = 100;
			["m12actionid"] = 0;
			["m12actionmsg"] = "";
			["m12actiontarget"] = "Target";
			["m12actionwait"] = 100;
			["m13actionid"] = 0;
			["m13actionmsg"] = "";
			["m13actiontarget"] = "Target";
			["m13actionwait"] = 100;
			["m14actionid"] = 0;
			["m14actionmsg"] = "";
			["m14actiontarget"] = "Target";
			["m14actionwait"] = 100;
			["m15actionid"] = 0;
			["m15actionmsg"] = "";
			["m15actiontarget"] = "Target";
			["m15actionwait"] = 100;
			["m16actionid"] = 0;
			["m16actionmsg"] = "";
			["m16actiontarget"] = "Target";
			["m16actionwait"] = 100;
			["m17actionid"] = 0;
			["m17actionmsg"] = "";
			["m17actiontarget"] = "Target";
			["m17actionwait"] = 100;
			["m18actionid"] = 0;
			["m18actionmsg"] = "";
			["m18actiontarget"] = "Target";
			["m18actionwait"] = 100;
			["m19actionid"] = 0;
			["m19actionmsg"] = "";
			["m19actiontarget"] = "Target";
			["m19actionwait"] = 100;
			["m1actionid"] = 0;
			["m1actionmsg"] = "";
			["m1actiontarget"] = "Target";
			["m1actionwait"] = 100;
			["m20actionid"] = 0;
			["m20actionmsg"] = "";
			["m20actiontarget"] = "Target";
			["m20actionwait"] = 100;
			["m2actionid"] = 0;
			["m2actionmsg"] = "";
			["m2actiontarget"] = "Target";
			["m2actionwait"] = 100;
			["m3actionid"] = 0;
			["m3actionmsg"] = "";
			["m3actiontarget"] = "Target";
			["m3actionwait"] = 100;
			["m4actionid"] = 0;
			["m4actionmsg"] = "";
			["m4actiontarget"] = "Target";
			["m4actionwait"] = 100;
			["m5actionid"] = 0;
			["m5actionmsg"] = "";
			["m5actiontarget"] = "Target";
			["m5actionwait"] = 100;
			["m6actionid"] = 0;
			["m6actionmsg"] = "";
			["m6actiontarget"] = "Target";
			["m6actionwait"] = 100;
			["m7actionid"] = 0;
			["m7actionmsg"] = "";
			["m7actiontarget"] = "Target";
			["m7actionwait"] = 100;
			["m8actionid"] = 0;
			["m8actionmsg"] = "";
			["m8actiontarget"] = "Target";
			["m8actionwait"] = 100;
			["m9actionid"] = 0;
			["m9actionmsg"] = "";
			["m9actiontarget"] = "Target";
			["m9actionwait"] = 100;
			["maxRange"] = 24;
			["minRange"] = 0;
			["name"] = "Prospect";
			["ncurrentaction"] = "";
			["npc"] = "0";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "0";
			["onlysolo"] = "0";
			["partysizelt"] = "0";
			["pbuff"] = "";
			["pbuffdura"] = 0;
			["pcskill"] = "";
			["petbuff"] = "";
			["petbuffdura"] = 0;
			["petnbuff"] = "";
			["petnbuffdura"] = 0;
			["pgskill"] = "";
			["pgtrg"] = "Direct";
			["phpb"] = 0;
			["phpl"] = 0;
			["pmppb"] = 0;
			["pmppl"] = 0;
			["pnbuff"] = "";
			["pnbuffdura"] = 0;
			["ppos"] = "None";
			["ppowb"] = 0;
			["ppowl"] = 0;
			["prio"] = 8;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptcount"] = 0;
			["pthpb"] = 0;
			["pthpl"] = 0;
			["ptkbuff"] = "0";
			["ptmpb"] = 0;
			["ptmpl"] = 0;
			["ptnbuff"] = "";
			["ptpb"] = 0;
			["ptpl"] = 0;
			["ptrg"] = "Any";
			["pttpb"] = 0;
			["pttpl"] = 0;
			["punderattack"] = "0";
			["punderattackmelee"] = "0";
			["pvepvp"] = "Both";
			["removebuff"] = "0";
			["secspassed"] = 0;
			["secspassedu"] = 0;
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "Action";
			["stype"] = "Action";
			["tacount"] = 0;
			["tahpl"] = 0;
			["tankedonlyaoe"] = "0";
			["tarange"] = 0;
			["tbuff"] = "";
			["tbuffdura"] = 0;
			["tbuffowner"] = "Player";
			["tcastids"] = "";
			["tcastonme"] = "0";
			["tcasttime"] = "0.0";
			["tcontids"] = "";
			["tecenter"] = "Auto";
			["tecount"] = 0;
			["tecount2"] = 0;
			["tehpavggt"] = 0;
			["televel"] = "Any";
			["terange"] = 0;
			["thpadv"] = 0;
			["thpb"] = 0;
			["thpcb"] = 0;
			["thpcl"] = 0;
			["thpl"] = 0;
			["tmpl"] = 0;
			["tnbuff"] = "";
			["tnbuffdura"] = 0;
			["tnbuffowner"] = "Player";
			["tncontids"] = "";
			["trg"] = "Target";
			["trgtype"] = "Any";
			["ttpl"] = 0;
			["type"] = 1;
			["used"] = "1";
		};
		[2] = {
			["alias"] = "";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gpbuff"] = "";
			["gpmax"] = 0;
			["gpmin"] = 0;
			["gpnbuff"] = "";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["id"] = 295;
			["isunspoiled"] = "0";
			["itemchancemax"] = 30;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["name"] = "Sharp Vision III";
			["prio"] = 9;
			["pskillg"] = "";
			["singleuseonly"] = "1";
			["type"] = 1;
			["used"] = "1";
		};
		[3] = {
			["alias"] = "";
			["chainend"] = "";
			["chainname"] = "";
			["chainstart"] = "";
			["charge"] = "";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "";
			["condition"] = "";
			["cpbuff"] = "";
			["cpnbuff"] = "";
			["dobuff"] = "";
			["enmityaoe"] = "";
			["filterfive"] = "";
			["filterfour"] = "";
			["filterone"] = "";
			["filterthree"] = "";
			["filtertwo"] = "";
			["frontalconeaoe"] = "";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "";
			["gpbuff"] = "";
			["gpmax"] = 0;
			["gpmin"] = 0;
			["gpnbuff"] = "";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "";
			["hprio2"] = "";
			["hprio3"] = "";
			["hprio4"] = "";
			["id"] = 294;
			["ignoremoving"] = "";
			["isunspoiled"] = "0";
			["itemchancemax"] = 30;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["m10actionmsg"] = "";
			["m10actiontarget"] = "";
			["m10actiontype"] = "";
			["m11actionmsg"] = "";
			["m11actiontarget"] = "";
			["m11actiontype"] = "";
			["m12actionmsg"] = "";
			["m12actiontarget"] = "";
			["m12actiontype"] = "";
			["m13actionmsg"] = "";
			["m13actiontarget"] = "";
			["m13actiontype"] = "";
			["m14actionmsg"] = "";
			["m14actiontarget"] = "";
			["m14actiontype"] = "";
			["m15actionmsg"] = "";
			["m15actiontarget"] = "";
			["m15actiontype"] = "";
			["m16actionmsg"] = "";
			["m16actiontarget"] = "";
			["m16actiontype"] = "";
			["m17actionmsg"] = "";
			["m17actiontarget"] = "";
			["m17actiontype"] = "";
			["m18actionmsg"] = "";
			["m18actiontarget"] = "";
			["m18actiontype"] = "";
			["m19actionmsg"] = "";
			["m19actiontarget"] = "";
			["m19actiontype"] = "";
			["m1actionmsg"] = "";
			["m1actiontarget"] = "";
			["m1actiontype"] = "";
			["m20actionmsg"] = "";
			["m20actiontarget"] = "";
			["m20actiontype"] = "";
			["m2actionmsg"] = "";
			["m2actiontarget"] = "";
			["m2actiontype"] = "";
			["m3actionmsg"] = "";
			["m3actiontarget"] = "";
			["m3actiontype"] = "";
			["m4actionmsg"] = "";
			["m4actiontarget"] = "";
			["m4actiontype"] = "";
			["m5actionmsg"] = "";
			["m5actiontarget"] = "";
			["m5actiontype"] = "";
			["m6actionmsg"] = "";
			["m6actiontarget"] = "";
			["m6actiontype"] = "";
			["m7actionmsg"] = "";
			["m7actiontarget"] = "";
			["m7actiontype"] = "";
			["m8actionmsg"] = "";
			["m8actiontarget"] = "";
			["m8actiontype"] = "";
			["m9actionmsg"] = "";
			["m9actiontarget"] = "";
			["m9actiontype"] = "";
			["name"] = "Field Mastery III";
			["ncurrentaction"] = "";
			["npc"] = "";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "";
			["onlysolo"] = "";
			["partysizelt"] = "";
			["pbuff"] = "";
			["pcskill"] = "";
			["petbuff"] = "";
			["petnbuff"] = "";
			["pgskill"] = "";
			["pgtrg"] = "";
			["pmprsgt"] = "";
			["pnbuff"] = "";
			["ppos"] = "";
			["prio"] = 10;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptkbuff"] = "";
			["ptnbuff"] = "";
			["ptrg"] = "";
			["punderattack"] = "";
			["punderattackmelee"] = "";
			["removebuff"] = "";
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "";
			["stype"] = "";
			["tankedonlyaoe"] = "";
			["tbuff"] = "";
			["tbuffowner"] = "";
			["tcastids"] = "";
			["tcastonme"] = "";
			["tcasttime"] = "";
			["tcontids"] = "";
			["tecenter"] = "";
			["televel"] = "";
			["tnbuff"] = "";
			["tnbuffowner"] = "";
			["tncontids"] = "";
			["trg"] = "";
			["trgtype"] = "";
			["type"] = 1;
			["used"] = "1";
			["whstack"] = "";
		};
		[4] = {
			["alias"] = "";
			["chainend"] = "";
			["chainname"] = "";
			["chainstart"] = "";
			["charge"] = "";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "";
			["comboskill"] = "Auto";
			["condition"] = "";
			["cpbuff"] = "";
			["cpnbuff"] = "";
			["dobuff"] = "";
			["doprev"] = "0";
			["enmityaoe"] = "";
			["filterfive"] = "";
			["filterfour"] = "";
			["filterone"] = "";
			["filterthree"] = "";
			["filtertwo"] = "";
			["frontalconeaoe"] = "";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "";
			["gcdtime"] = 0.5;
			["gcdtimelt"] = 2.5;
			["gpbuff"] = "";
			["gpmax"] = 390;
			["gpmin"] = 0;
			["gpnbuff"] = "218";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "";
			["hprio2"] = "";
			["hprio3"] = "";
			["hprio4"] = "";
			["hpriohp"] = 0;
			["id"] = 237;
			["ignoremoving"] = "";
			["isunspoiled"] = "0";
			["itemchancemax"] = 80;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["levelmax"] = 0;
			["levelmin"] = 0;
			["m10actionid"] = 0;
			["m10actionmsg"] = "";
			["m10actiontarget"] = "Target";
			["m10actionwait"] = 100;
			["m11actionid"] = 0;
			["m11actionmsg"] = "";
			["m11actiontarget"] = "Target";
			["m11actionwait"] = 100;
			["m12actionid"] = 0;
			["m12actionmsg"] = "";
			["m12actiontarget"] = "Target";
			["m12actionwait"] = 100;
			["m13actionid"] = 0;
			["m13actionmsg"] = "";
			["m13actiontarget"] = "Target";
			["m13actionwait"] = 100;
			["m14actionid"] = 0;
			["m14actionmsg"] = "";
			["m14actiontarget"] = "Target";
			["m14actionwait"] = 100;
			["m15actionid"] = 0;
			["m15actionmsg"] = "";
			["m15actiontarget"] = "Target";
			["m15actionwait"] = 100;
			["m16actionid"] = 0;
			["m16actionmsg"] = "";
			["m16actiontarget"] = "Target";
			["m16actionwait"] = 100;
			["m17actionid"] = 0;
			["m17actionmsg"] = "";
			["m17actiontarget"] = "Target";
			["m17actionwait"] = 100;
			["m18actionid"] = 0;
			["m18actionmsg"] = "";
			["m18actiontarget"] = "Target";
			["m18actionwait"] = 100;
			["m19actionid"] = 0;
			["m19actionmsg"] = "";
			["m19actiontarget"] = "Target";
			["m19actionwait"] = 100;
			["m1actionid"] = 0;
			["m1actionmsg"] = "";
			["m1actiontarget"] = "Target";
			["m1actionwait"] = 100;
			["m20actionid"] = 0;
			["m20actionmsg"] = "";
			["m20actiontarget"] = "Target";
			["m20actionwait"] = 100;
			["m2actionid"] = 0;
			["m2actionmsg"] = "";
			["m2actiontarget"] = "Target";
			["m2actionwait"] = 100;
			["m3actionid"] = 0;
			["m3actionmsg"] = "";
			["m3actiontarget"] = "Target";
			["m3actionwait"] = 100;
			["m4actionid"] = 0;
			["m4actionmsg"] = "";
			["m4actiontarget"] = "Target";
			["m4actionwait"] = 100;
			["m5actionid"] = 0;
			["m5actionmsg"] = "";
			["m5actiontarget"] = "Target";
			["m5actionwait"] = 100;
			["m6actionid"] = 0;
			["m6actionmsg"] = "";
			["m6actiontarget"] = "Target";
			["m6actionwait"] = 100;
			["m7actionid"] = 0;
			["m7actionmsg"] = "";
			["m7actiontarget"] = "Target";
			["m7actionwait"] = 100;
			["m8actionid"] = 0;
			["m8actionmsg"] = "";
			["m8actiontarget"] = "Target";
			["m8actionwait"] = 100;
			["m9actionid"] = 0;
			["m9actionmsg"] = "";
			["m9actiontarget"] = "Target";
			["m9actionwait"] = 100;
			["maxRange"] = 24;
			["minRange"] = 0;
			["name"] = " Sharp Vision II";
			["ncurrentaction"] = "";
			["npc"] = "";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "";
			["onlysolo"] = "";
			["partysizelt"] = "";
			["pbuff"] = "";
			["pbuffdura"] = 0;
			["pcskill"] = "";
			["petbuff"] = "";
			["petbuffdura"] = 0;
			["petnbuff"] = "";
			["petnbuffdura"] = 0;
			["pgskill"] = "";
			["pgtrg"] = "";
			["phpb"] = 0;
			["phpl"] = 0;
			["pmppb"] = 0;
			["pmppl"] = 0;
			["pnbuff"] = "";
			["pnbuffdura"] = 0;
			["ppos"] = "";
			["ppowb"] = 0;
			["ppowl"] = 0;
			["prio"] = 11;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptcount"] = 0;
			["pthpb"] = 0;
			["pthpl"] = 0;
			["ptkbuff"] = "";
			["ptmpb"] = 0;
			["ptmpl"] = 0;
			["ptnbuff"] = "";
			["ptpb"] = 0;
			["ptpl"] = 0;
			["ptrg"] = "";
			["pttpb"] = 0;
			["pttpl"] = 0;
			["punderattack"] = "";
			["punderattackmelee"] = "";
			["pvepvp"] = "Both";
			["removebuff"] = "";
			["secspassed"] = 0;
			["secspassedu"] = 0;
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "";
			["stype"] = "";
			["tacount"] = 0;
			["tahpl"] = 0;
			["tankedonlyaoe"] = "";
			["tarange"] = 0;
			["tbuff"] = "";
			["tbuffdura"] = 0;
			["tbuffowner"] = "";
			["tcastids"] = "";
			["tcastonme"] = "";
			["tcasttime"] = "";
			["tcontids"] = "";
			["tecenter"] = "";
			["tecount"] = 0;
			["tecount2"] = 0;
			["tehpavggt"] = 0;
			["televel"] = "";
			["terange"] = 0;
			["thpadv"] = 0;
			["thpb"] = 0;
			["thpcb"] = 0;
			["thpcl"] = 0;
			["thpl"] = 0;
			["tmpl"] = 0;
			["tnbuff"] = "";
			["tnbuffdura"] = 0;
			["tnbuffowner"] = "";
			["tncontids"] = "";
			["trg"] = "";
			["trgtype"] = "";
			["ttpl"] = 0;
			["type"] = 1;
			["used"] = "1";
			["whstack"] = "";
		};
		[5] = {
			["chainend"] = "0";
			["chainname"] = "";
			["chainstart"] = "0";
			["charge"] = "0";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "In Combat";
			["comboskill"] = "Auto";
			["dobuff"] = "0";
			["doprev"] = "0";
			["enmityaoe"] = "0";
			["filterfive"] = "Ignore";
			["filterfour"] = "Ignore";
			["filterone"] = "Ignore";
			["filterthree"] = "Ignore";
			["filtertwo"] = "Ignore";
			["frontalconeaoe"] = "0";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "Auto";
			["gcdtime"] = 0.5;
			["gcdtimelt"] = 2.5;
			["gpbuff"] = "";
			["gpmax"] = 390;
			["gpmin"] = 0;
			["gpnbuff"] = "218";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "None";
			["hprio2"] = "None";
			["hprio3"] = "None";
			["hprio4"] = "None";
			["hpriohp"] = 0;
			["id"] = 220;
			["ignoremoving"] = "0";
			["isunspoiled"] = "0";
			["itemchancemax"] = 80;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["levelmax"] = 0;
			["levelmin"] = 0;
			["m10actionid"] = 0;
			["m10actionmsg"] = "";
			["m10actiontarget"] = "Target";
			["m10actionwait"] = 100;
			["m11actionid"] = 0;
			["m11actionmsg"] = "";
			["m11actiontarget"] = "Target";
			["m11actionwait"] = 100;
			["m12actionid"] = 0;
			["m12actionmsg"] = "";
			["m12actiontarget"] = "Target";
			["m12actionwait"] = 100;
			["m13actionid"] = 0;
			["m13actionmsg"] = "";
			["m13actiontarget"] = "Target";
			["m13actionwait"] = 100;
			["m14actionid"] = 0;
			["m14actionmsg"] = "";
			["m14actiontarget"] = "Target";
			["m14actionwait"] = 100;
			["m15actionid"] = 0;
			["m15actionmsg"] = "";
			["m15actiontarget"] = "Target";
			["m15actionwait"] = 100;
			["m16actionid"] = 0;
			["m16actionmsg"] = "";
			["m16actiontarget"] = "Target";
			["m16actionwait"] = 100;
			["m17actionid"] = 0;
			["m17actionmsg"] = "";
			["m17actiontarget"] = "Target";
			["m17actionwait"] = 100;
			["m18actionid"] = 0;
			["m18actionmsg"] = "";
			["m18actiontarget"] = "Target";
			["m18actionwait"] = 100;
			["m19actionid"] = 0;
			["m19actionmsg"] = "";
			["m19actiontarget"] = "Target";
			["m19actionwait"] = 100;
			["m1actionid"] = 0;
			["m1actionmsg"] = "";
			["m1actiontarget"] = "Target";
			["m1actionwait"] = 100;
			["m20actionid"] = 0;
			["m20actionmsg"] = "";
			["m20actiontarget"] = "Target";
			["m20actionwait"] = 100;
			["m2actionid"] = 0;
			["m2actionmsg"] = "";
			["m2actiontarget"] = "Target";
			["m2actionwait"] = 100;
			["m3actionid"] = 0;
			["m3actionmsg"] = "";
			["m3actiontarget"] = "Target";
			["m3actionwait"] = 100;
			["m4actionid"] = 0;
			["m4actionmsg"] = "";
			["m4actiontarget"] = "Target";
			["m4actionwait"] = 100;
			["m5actionid"] = 0;
			["m5actionmsg"] = "";
			["m5actiontarget"] = "Target";
			["m5actionwait"] = 100;
			["m6actionid"] = 0;
			["m6actionmsg"] = "";
			["m6actiontarget"] = "Target";
			["m6actionwait"] = 100;
			["m7actionid"] = 0;
			["m7actionmsg"] = "";
			["m7actiontarget"] = "Target";
			["m7actionwait"] = 100;
			["m8actionid"] = 0;
			["m8actionmsg"] = "";
			["m8actiontarget"] = "Target";
			["m8actionwait"] = 100;
			["m9actionid"] = 0;
			["m9actionmsg"] = "";
			["m9actiontarget"] = "Target";
			["m9actionwait"] = 100;
			["maxRange"] = 24;
			["minRange"] = 0;
			["name"] = "Field Mastery II";
			["ncurrentaction"] = "";
			["npc"] = "0";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "0";
			["onlysolo"] = "0";
			["partysizelt"] = "0";
			["pbuff"] = "";
			["pbuffdura"] = 0;
			["pcskill"] = "";
			["petbuff"] = "";
			["petbuffdura"] = 0;
			["petnbuff"] = "";
			["petnbuffdura"] = 0;
			["pgskill"] = "";
			["pgtrg"] = "Direct";
			["phpb"] = 0;
			["phpl"] = 0;
			["pmppb"] = 0;
			["pmppl"] = 0;
			["pnbuff"] = "";
			["pnbuffdura"] = 0;
			["ppos"] = "None";
			["ppowb"] = 0;
			["ppowl"] = 0;
			["prio"] = 12;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptcount"] = 0;
			["pthpb"] = 0;
			["pthpl"] = 0;
			["ptkbuff"] = "0";
			["ptmpb"] = 0;
			["ptmpl"] = 0;
			["ptnbuff"] = "";
			["ptpb"] = 0;
			["ptpl"] = 0;
			["ptrg"] = "Any";
			["pttpb"] = 0;
			["pttpl"] = 0;
			["punderattack"] = "0";
			["punderattackmelee"] = "0";
			["pvepvp"] = "Both";
			["removebuff"] = "0";
			["secspassed"] = 0;
			["secspassedu"] = 0;
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "Action";
			["stype"] = "Action";
			["tacount"] = 0;
			["tahpl"] = 0;
			["tankedonlyaoe"] = "0";
			["tarange"] = 0;
			["tbuff"] = "";
			["tbuffdura"] = 0;
			["tbuffowner"] = "Player";
			["tcastids"] = "";
			["tcastonme"] = "0";
			["tcasttime"] = "0.0";
			["tcontids"] = "";
			["tecenter"] = "Auto";
			["tecount"] = 0;
			["tecount2"] = 0;
			["tehpavggt"] = 0;
			["televel"] = "Any";
			["terange"] = 0;
			["thpadv"] = 0;
			["thpb"] = 0;
			["thpcb"] = 0;
			["thpcl"] = 0;
			["thpl"] = 0;
			["tmpl"] = 0;
			["tnbuff"] = "";
			["tnbuffdura"] = 0;
			["tnbuffowner"] = "Player";
			["tncontids"] = "";
			["trg"] = "Target";
			["trgtype"] = "Any";
			["ttpl"] = 0;
			["type"] = 1;
			["used"] = "1";
		};
		[6] = {
			["chainend"] = "0";
			["chainname"] = "";
			["chainstart"] = "0";
			["charge"] = "0";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "In Combat";
			["comboskill"] = "Auto";
			["dobuff"] = "0";
			["doprev"] = "0";
			["enmityaoe"] = "0";
			["filterfive"] = "Ignore";
			["filterfour"] = "Ignore";
			["filterone"] = "Ignore";
			["filterthree"] = "Ignore";
			["filtertwo"] = "Ignore";
			["frontalconeaoe"] = "0";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "Auto";
			["gcdtime"] = 0.5;
			["gcdtimelt"] = 2.5;
			["gpbuff"] = "";
			["gpmax"] = 390;
			["gpmin"] = 0;
			["gpnbuff"] = "218";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "None";
			["hprio2"] = "None";
			["hprio3"] = "None";
			["hprio4"] = "None";
			["hpriohp"] = 0;
			["id"] = 235;
			["ignoremoving"] = "0";
			["isunspoiled"] = "0";
			["itemchancemax"] = 90;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["levelmax"] = 0;
			["levelmin"] = 0;
			["m10actionid"] = 0;
			["m10actionmsg"] = "";
			["m10actiontarget"] = "Target";
			["m10actionwait"] = 100;
			["m11actionid"] = 0;
			["m11actionmsg"] = "";
			["m11actiontarget"] = "Target";
			["m11actionwait"] = 100;
			["m12actionid"] = 0;
			["m12actionmsg"] = "";
			["m12actiontarget"] = "Target";
			["m12actionwait"] = 100;
			["m13actionid"] = 0;
			["m13actionmsg"] = "";
			["m13actiontarget"] = "Target";
			["m13actionwait"] = 100;
			["m14actionid"] = 0;
			["m14actionmsg"] = "";
			["m14actiontarget"] = "Target";
			["m14actionwait"] = 100;
			["m15actionid"] = 0;
			["m15actionmsg"] = "";
			["m15actiontarget"] = "Target";
			["m15actionwait"] = 100;
			["m16actionid"] = 0;
			["m16actionmsg"] = "";
			["m16actiontarget"] = "Target";
			["m16actionwait"] = 100;
			["m17actionid"] = 0;
			["m17actionmsg"] = "";
			["m17actiontarget"] = "Target";
			["m17actionwait"] = 100;
			["m18actionid"] = 0;
			["m18actionmsg"] = "";
			["m18actiontarget"] = "Target";
			["m18actionwait"] = 100;
			["m19actionid"] = 0;
			["m19actionmsg"] = "";
			["m19actiontarget"] = "Target";
			["m19actionwait"] = 100;
			["m1actionid"] = 0;
			["m1actionmsg"] = "";
			["m1actiontarget"] = "Target";
			["m1actionwait"] = 100;
			["m20actionid"] = 0;
			["m20actionmsg"] = "";
			["m20actiontarget"] = "Target";
			["m20actionwait"] = 100;
			["m2actionid"] = 0;
			["m2actionmsg"] = "";
			["m2actiontarget"] = "Target";
			["m2actionwait"] = 100;
			["m3actionid"] = 0;
			["m3actionmsg"] = "";
			["m3actiontarget"] = "Target";
			["m3actionwait"] = 100;
			["m4actionid"] = 0;
			["m4actionmsg"] = "";
			["m4actiontarget"] = "Target";
			["m4actionwait"] = 100;
			["m5actionid"] = 0;
			["m5actionmsg"] = "";
			["m5actiontarget"] = "Target";
			["m5actionwait"] = 100;
			["m6actionid"] = 0;
			["m6actionmsg"] = "";
			["m6actiontarget"] = "Target";
			["m6actionwait"] = 100;
			["m7actionid"] = 0;
			["m7actionmsg"] = "";
			["m7actiontarget"] = "Target";
			["m7actionwait"] = 100;
			["m8actionid"] = 0;
			["m8actionmsg"] = "";
			["m8actiontarget"] = "Target";
			["m8actionwait"] = 100;
			["m9actionid"] = 0;
			["m9actionmsg"] = "";
			["m9actiontarget"] = "Target";
			["m9actionwait"] = 100;
			["maxRange"] = 24;
			["minRange"] = 0;
			["name"] = "Sharp Vision";
			["ncurrentaction"] = "";
			["npc"] = "0";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "0";
			["onlysolo"] = "0";
			["partysizelt"] = "0";
			["pbuff"] = "";
			["pbuffdura"] = 0;
			["pcskill"] = "";
			["petbuff"] = "";
			["petbuffdura"] = 0;
			["petnbuff"] = "";
			["petnbuffdura"] = 0;
			["pgskill"] = "";
			["pgtrg"] = "Direct";
			["phpb"] = 0;
			["phpl"] = 0;
			["pmppb"] = 0;
			["pmppl"] = 0;
			["pnbuff"] = "";
			["pnbuffdura"] = 0;
			["ppos"] = "None";
			["ppowb"] = 0;
			["ppowl"] = 0;
			["prio"] = 13;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptcount"] = 0;
			["pthpb"] = 0;
			["pthpl"] = 0;
			["ptkbuff"] = "0";
			["ptmpb"] = 0;
			["ptmpl"] = 0;
			["ptnbuff"] = "";
			["ptpb"] = 0;
			["ptpl"] = 0;
			["ptrg"] = "Any";
			["pttpb"] = 0;
			["pttpl"] = 0;
			["punderattack"] = "0";
			["punderattackmelee"] = "0";
			["pvepvp"] = "Both";
			["removebuff"] = "0";
			["secspassed"] = 0;
			["secspassedu"] = 0;
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "Action";
			["stype"] = "Action";
			["tacount"] = 0;
			["tahpl"] = 0;
			["tankedonlyaoe"] = "0";
			["tarange"] = 0;
			["tbuff"] = "";
			["tbuffdura"] = 0;
			["tbuffowner"] = "Player";
			["tcastids"] = "";
			["tcastonme"] = "0";
			["tcasttime"] = "0.0";
			["tcontids"] = "";
			["tecenter"] = "Auto";
			["tecount"] = 0;
			["tecount2"] = 0;
			["tehpavggt"] = 0;
			["televel"] = "Any";
			["terange"] = 0;
			["thpadv"] = 0;
			["thpb"] = 0;
			["thpcb"] = 0;
			["thpcl"] = 0;
			["thpl"] = 0;
			["tmpl"] = 0;
			["tnbuff"] = "";
			["tnbuffdura"] = 0;
			["tnbuffowner"] = "Player";
			["tncontids"] = "";
			["trg"] = "Target";
			["trgtype"] = "Any";
			["ttpl"] = 0;
			["type"] = 1;
			["used"] = "1";
		};
		[7] = {
			["alias"] = "";
			["chainend"] = "";
			["chainname"] = "";
			["chainstart"] = "";
			["charge"] = "";
			["collraritylt"] = 0;
			["collrarityltpct"] = 0;
			["collweareq"] = 0;
			["collweargt"] = 0;
			["collwearlt"] = 0;
			["collwearltpct"] = 0;
			["combat"] = "";
			["comboskill"] = "Auto";
			["condition"] = "";
			["cpbuff"] = "";
			["cpnbuff"] = "";
			["dobuff"] = "";
			["doprev"] = "0";
			["enmityaoe"] = "";
			["filterfive"] = "";
			["filterfour"] = "";
			["filterone"] = "";
			["filterthree"] = "";
			["filtertwo"] = "";
			["frontalconeaoe"] = "";
			["gatherattempts"] = 0;
			["gatherattemptsmax"] = 0;
			["gcd"] = "";
			["gcdtime"] = 0.5;
			["gcdtimelt"] = 2.5;
			["gpbuff"] = "";
			["gpmax"] = 390;
			["gpmin"] = 0;
			["gpnbuff"] = "218";
			["gsecspassed"] = 0;
			["hasitem"] = "";
			["hprio1"] = "";
			["hprio2"] = "";
			["hprio3"] = "";
			["hprio4"] = "";
			["hpriohp"] = 0;
			["id"] = 218;
			["ignoremoving"] = "";
			["isunspoiled"] = "0";
			["itemchancemax"] = 90;
			["itemhqchancemin"] = 0;
			["lastcast"] = 0;
			["lastcastunique"] = {
			};
			["levelmax"] = 0;
			["levelmin"] = 0;
			["m10actionid"] = 0;
			["m10actionmsg"] = "";
			["m10actiontarget"] = "Target";
			["m10actionwait"] = 100;
			["m11actionid"] = 0;
			["m11actionmsg"] = "";
			["m11actiontarget"] = "Target";
			["m11actionwait"] = 100;
			["m12actionid"] = 0;
			["m12actionmsg"] = "";
			["m12actiontarget"] = "Target";
			["m12actionwait"] = 100;
			["m13actionid"] = 0;
			["m13actionmsg"] = "";
			["m13actiontarget"] = "Target";
			["m13actionwait"] = 100;
			["m14actionid"] = 0;
			["m14actionmsg"] = "";
			["m14actiontarget"] = "Target";
			["m14actionwait"] = 100;
			["m15actionid"] = 0;
			["m15actionmsg"] = "";
			["m15actiontarget"] = "Target";
			["m15actionwait"] = 100;
			["m16actionid"] = 0;
			["m16actionmsg"] = "";
			["m16actiontarget"] = "Target";
			["m16actionwait"] = 100;
			["m17actionid"] = 0;
			["m17actionmsg"] = "";
			["m17actiontarget"] = "Target";
			["m17actionwait"] = 100;
			["m18actionid"] = 0;
			["m18actionmsg"] = "";
			["m18actiontarget"] = "Target";
			["m18actionwait"] = 100;
			["m19actionid"] = 0;
			["m19actionmsg"] = "";
			["m19actiontarget"] = "Target";
			["m19actionwait"] = 100;
			["m1actionid"] = 0;
			["m1actionmsg"] = "";
			["m1actiontarget"] = "Target";
			["m1actionwait"] = 100;
			["m20actionid"] = 0;
			["m20actionmsg"] = "";
			["m20actiontarget"] = "Target";
			["m20actionwait"] = 100;
			["m2actionid"] = 0;
			["m2actionmsg"] = "";
			["m2actiontarget"] = "Target";
			["m2actionwait"] = 100;
			["m3actionid"] = 0;
			["m3actionmsg"] = "";
			["m3actiontarget"] = "Target";
			["m3actionwait"] = 100;
			["m4actionid"] = 0;
			["m4actionmsg"] = "";
			["m4actiontarget"] = "Target";
			["m4actionwait"] = 100;
			["m5actionid"] = 0;
			["m5actionmsg"] = "";
			["m5actiontarget"] = "Target";
			["m5actionwait"] = 100;
			["m6actionid"] = 0;
			["m6actionmsg"] = "";
			["m6actiontarget"] = "Target";
			["m6actionwait"] = 100;
			["m7actionid"] = 0;
			["m7actionmsg"] = "";
			["m7actiontarget"] = "Target";
			["m7actionwait"] = 100;
			["m8actionid"] = 0;
			["m8actionmsg"] = "";
			["m8actiontarget"] = "Target";
			["m8actionwait"] = 100;
			["m9actionid"] = 0;
			["m9actionmsg"] = "";
			["m9actiontarget"] = "Target";
			["m9actionwait"] = 100;
			["maxRange"] = 24;
			["minRange"] = 0;
			["name"] = "Field Mastery";
			["ncurrentaction"] = "";
			["npc"] = "";
			["npcskill"] = "";
			["npgskill"] = "";
			["npskill"] = "";
			["onlyparty"] = "";
			["onlysolo"] = "";
			["partysizelt"] = "";
			["pbuff"] = "";
			["pbuffdura"] = 0;
			["pcskill"] = "";
			["petbuff"] = "";
			["petbuffdura"] = 0;
			["petnbuff"] = "";
			["petnbuffdura"] = 0;
			["pgskill"] = "";
			["pgtrg"] = "";
			["phpb"] = 0;
			["phpl"] = 0;
			["pmppb"] = 0;
			["pmppl"] = 0;
			["pnbuff"] = "";
			["pnbuffdura"] = 0;
			["ppos"] = "";
			["ppowb"] = 0;
			["ppowl"] = 0;
			["prio"] = 14;
			["pskill"] = "";
			["pskillg"] = "";
			["ptbuff"] = "";
			["ptcount"] = 0;
			["pthpb"] = 0;
			["pthpl"] = 0;
			["ptkbuff"] = "";
			["ptmpb"] = 0;
			["ptmpl"] = 0;
			["ptnbuff"] = "";
			["ptpb"] = 0;
			["ptpl"] = 0;
			["ptrg"] = "";
			["pttpb"] = 0;
			["pttpl"] = 0;
			["punderattack"] = "";
			["punderattackmelee"] = "";
			["pvepvp"] = "Both";
			["removebuff"] = "";
			["secspassed"] = 0;
			["secspassedu"] = 0;
			["singleuseonly"] = "1";
			["skncdtimemax"] = "";
			["skncdtimemin"] = "";
			["sknoffcd"] = "";
			["sknready"] = "";
			["skoffcd"] = "";
			["skready"] = "";
			["sktype"] = "";
			["stype"] = "";
			["tacount"] = 0;
			["tahpl"] = 0;
			["tankedonlyaoe"] = "";
			["tarange"] = 0;
			["tbuff"] = "";
			["tbuffdura"] = 0;
			["tbuffowner"] = "";
			["tcastids"] = "";
			["tcastonme"] = "";
			["tcasttime"] = "";
			["tcontids"] = "";
			["tecenter"] = "";
			["tecount"] = 0;
			["tecount2"] = 0;
			["tehpavggt"] = 0;
			["televel"] = "";
			["terange"] = 0;
			["thpadv"] = 0;
			["thpb"] = 0;
			["thpcb"] = 0;
			["thpcl"] = 0;
			["thpl"] = 0;
			["tmpl"] = 0;
			["tnbuff"] = "";
			["tnbuffdura"] = 0;
			["tnbuffowner"] = "";
			["tncontids"] = "";
			["trg"] = "";
			["trgtype"] = "";
			["ttpl"] = 0;
			["type"] = 1;
			["used"] = "1";
			["whstack"] = "";
		};
	};
	["version"] = 2;
}
return obj1
