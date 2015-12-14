---------------------------------------------------------------------------------------------
--ADD_TASK CNEs
--These are cnes which are used to check the current game state and add a new task/subtask
--based on the needs of the parent task they are assigned to. They differ from the task
--completion CNEs since they don't perform any action other than to queue a new task. 
--Every task must have a CNE like this to queue it when appropriate. They can be placed
--in either the process elements or the overwatch elements for a task based on the priority
--of the task they queue. MOVETOTARGET, for instance, should be placed in the overwatch
--list since it needs to be checked continually for moving targets; COMBAT can be placed
--into the process list since there is no need to queue another combat task until the
--previous combat task is completed and control returns to the parent task.
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--ADD_KILLTARGET: If (current target hp > 0) Then (add longterm killtarget task)
--Adds a killtarget task if target hp > 0
---------------------------------------------------------------------------------------------
c_add_killtarget = inheritsFrom( ml_cause )
e_add_killtarget = inheritsFrom( ml_effect )
c_add_killtarget.oocCastTimer = 0
function c_add_killtarget:evaluate()
	-- block killtarget for grinding when user has specified "Fates Only"
	if ((ml_task_hub:CurrentTask().name == "LT_GRIND" or ml_task_hub:CurrentTask().name == "LT_PARTY" ) and gFatesOnly == "1") then
		if (ml_task_hub:CurrentTask().name == "LT_GRIND") then
			local aggro = GetNearestAggro()
			if ValidTable(aggro) then
				if (aggro.hp.current > 0 and aggro.id and aggro.id ~= 0 and aggro.distance <= 30) then
					c_add_killtarget.targetid = aggro.id
					d("Adding an aggro target in first block.")
					return true
				end
			end
		end
        return false
    end
	
	if (gBotMode == GetString("partyMode") and not IsLeader()) then
        return false
    end
	
	if not (ml_task_hub:ThisTask().name == "LT_FATE" and ml_task_hub:CurrentTask().name == "MOVETOPOS") then
		local aggro = GetNearestAggro()
		if ValidTable(aggro) then
			if (aggro.hp.current > 0 and aggro.id and aggro.id ~= 0 and aggro.distance <= 30) then
				d("Adding an aggro target.")
				c_add_killtarget.targetid = aggro.id
				return true
			end
		end 
	end
    
	if (SkillMgr.Cast( Player, true)) then
		c_add_killtarget.oocCastTimer = Now() + 1500
		return false
	end
	
	if (ml_global_information.Player_IsCasting or Now() < c_add_killtarget.oocCastTimer) then
		return false
	end
	
	local target = ml_task_hub:CurrentTask().targetFunction()
    if (ValidTable(target)) then
        if(target.hp.current > 0 and target.id ~= nil and target.id ~= 0) then
			d("Picked target in normal block.")
            c_add_killtarget.targetid = target.id
            return true
        end
    end
    
    return false
end
function e_add_killtarget:execute()
	local newTask = ffxiv_task_grindCombat.Create()
	newTask.targetid = c_add_killtarget.targetid
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_killaggrotarget = inheritsFrom( ml_cause )
e_killaggrotarget = inheritsFrom( ml_effect )
c_killaggrotarget.targetid = 0
function c_killaggrotarget:evaluate()
	if (gBotMode == GetString("partyMode") and IsLeader() ) then
        return false
    end
	
	if (gBotMode == GetString("partyMode")) then
		local leader, isEntity = GetPartyLeader()	
		if (leader and leader.id ~= 0) then
			local entity = EntityList:Get(leader.id)
			if ( entity  and entity.id ~= 0) then
				if ((entity.incombat and entity.distance > 7) or (not entity.incombat and entity.distance > 10) or (entity.ismounted) or Player.ismounted) then
					return false
				end
			end
		end
	end
	
    local target = GetNearestAggro()
	if (ValidTable(target)) then
		if(target.hp.current > 0 and target.id ~= nil and target.id ~= 0) then
			c_killaggrotarget.targetid = target.id
			return true
		end
	end
    
    return false
end
function e_killaggrotarget:execute()
	local newTask = ffxiv_task_grindCombat.Create()
	Player:SetTarget(c_killaggrotarget.targetid)
    newTask.targetid = c_killaggrotarget.targetid
    ml_task_hub:CurrentTask():AddSubTask(newTask)
end
---------------------------------------------------------------------------------------------
---- minion attacks the target the leader has
--Adds a task to use a combat routine to attack/kill target 
---------------------------------------------------------------------------------------------
c_assistleader = inheritsFrom( ml_cause )
e_assistleader = inheritsFrom( ml_effect )
c_assistleader.targetid = nil
function c_assistleader:evaluate()
    if (gBotMode == GetString("partyMode") and IsLeader()) then
        return false
    end
	
    local leader, isEntity = GetPartyLeader()	
    if (ValidTable(leader) and isEntity) then
		local leadtarget = leader.targetid
		if (leader.ismounted or not leader.incombat or not leadtarget or leadtarget == 0) then
			return false			
		end

		if (ml_task_hub:ThisTask().subtask) then
			local task = ml_task_hub:ThisTask().subtask
			if (task.name == "GRIND_COMBAT" and task.targetid == leadtarget) then
				return false
			end
		end
		
		local target = EntityList:Get(leadtarget)				
		if ( ValidTable(target) and target.alive and (target.onmesh or InCombatRange(target.id))) then
			c_assistleader.targetid = target.id
			return true
		end
    end
    
    return false
end
function e_assistleader:execute()
	local id = c_assistleader.targetid
	if ( Player.ismounted ) then
		Dismount()
		return
	end
	
	if (ml_task_hub:CurrentTask().name == "GRIND_COMBAT") then
		ml_task_hub:CurrentTask().targetid = id
	else
		local newTask = ffxiv_task_grindCombat.Create()
		newTask.targetid = id 
		newTask.noFateSync = true
		ml_task_hub:CurrentTask():AddSubTask(newTask)
	end
end

---------------------------------------------------------------------------------------------
--ADD_COMBAT: If (target hp > 0) Then (add combat task)
--Adds a task to use a combat routine to attack/kill target 
---------------------------------------------------------------------------------------------
c_add_combat = inheritsFrom( ml_cause )
e_add_combat = inheritsFrom( ml_effect )
function c_add_combat:evaluate()
	
    local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
	
	--Do some special checking here for hunts.
	if (target) then
		if (ml_task_hub:RootTask().name == "LT_HUNT") then
			if (ml_task_hub:CurrentTask().rank == "S") then
				local allies = EntityList("alive,friendly,chartype=4,targetable,maxdistance=50")
				if ((target.hp.percent > tonumber(gHuntSRankHP)) and (not allies or TableSize(allies) < tonumber(gHuntSRankAllies))) then
					return false
				end
			elseif (ml_task_hub:CurrentTask().rank == "A") then
				local allies = EntityList("alive,friendly,chartype=4,targetable,maxdistance=50")
				if ((target.hp.percent > tonumber(gHuntARankHP)) and (not allies or TableSize(allies) < tonumber(gHuntARankAllies))) then
					return false
				end
			elseif (ml_task_hub:CurrentTask().rank == "B") then
				if (Now() < ml_task_hub:CurrentTask().waitTimer and target.targetid == 0) then
					return false
				end
			end
		end
	end
	
	--If we made it this far without stopping, assume the target can be safely engaged.
	if (not ml_task_hub:CurrentTask().canEngage) then
		ml_task_hub:CurrentTask().canEngage = true
	end
	
	if (target and target.id ~= 0) then
		return InCombatRange(target.id) and target.alive and not IsMounting()
	end
        
    return false
end
function e_add_combat:execute()
	Dismount()
	
	if (IsMounting() or Player.ismounted) then	
		return
	end
	
    if ( gSMactive == "1" ) then
        local newTask = ffxiv_task_skillmgrAttack.Create()
        newTask.targetid = ml_task_hub:CurrentTask().targetid
        ml_task_hub:CurrentTask():AddSubTask(newTask)
    else
		ml_debug("Skill manager is not active, defaulting to class routine.")
        local newTask = ml_global_information.CurrentClass.Create()
        newTask.targetid = ml_task_hub:CurrentTask().targetid
        ml_task_hub:CurrentTask():AddSubTask(newTask)
    end
end

---------------------------------------------------------------------------------------------
--ADD_FATE: If (fate of proper level is on mesh) Then (add longterm fate task)
--Adds a fate task if there is a fate on the mesh
---------------------------------------------------------------------------------------------
c_add_fate = inheritsFrom( ml_cause )
e_add_fate = inheritsFrom( ml_effect )
c_add_fate.fate = {}
function c_add_fate:evaluate()
    if (gBotMode == GetString("partyMode") and not IsLeader()) then
		return false
    end
	
	c_add_fate.fate = {}
    
    if (gDoFates == "1") then
		local fate = GetClosestFate(ml_global_information.Player_Position,true)
		if (fate and fate.completion < 100) then
			c_add_fate.fate = fate
			return true
		end
    end
    
    return false
end
function e_add_fate:execute()
    local newTask = ffxiv_task_fate.Create()
    newTask.fateid = c_add_fate.fate.id
	newTask.fatePos = {x = c_add_fate.fate.x, y = c_add_fate.fate.y, z = c_add_fate.fate.z}
    ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_nextatma = inheritsFrom( ml_cause )
e_nextatma = inheritsFrom( ml_effect )
e_nextatma.atma = nil
function c_nextatma:evaluate()	
	if (gAtma == "0" or ml_global_information.Player_InCombat or ffxiv_task_grind.inFate or ml_global_information.Player_IsLoading) then
		return false
	end
	
	local map = ml_global_information.Player_Map
	local mapFound = false
	local mapItem = nil
	local itemFound = false
	local getNext = false
	local jpTime = GetJPTime()
	
	--First loop, check for best atma based on JP time theory.
	for a, atma in pairs(ffxiv_task_grind.atmas) do
		if ((tonumber(atma.hour) == jpTime.hour and jpTime.min <= 55) or
			(tonumber(atma.hour) == AddHours12(jpTime.hour,1) and jpTime.min > 55)) then
			local haveBest = false
			--local bestAtma = a
			for x=0,3 do
				local inv = Inventory("type="..tostring(x))
				for i, item in pairs(inv) do
					if (item.id == atma.item) then
						haveBest = true
					end
					if (haveBest) then	
						break
					end
				end
				if (haveBest) then
					break
				end
			end
		
			if (not haveBest) then
				if (atma.map ~= map) then
					e_nextatma.atma = atma
					return true
				end
			end
		end
	end
	
	--Second loop, check to see if we have this map's atma, and return false if we still don't have it yet.
	for a, atma in pairs(ffxiv_task_grind.atmas) do
		if (atma.map == map) then
			local haveClosest = false
			
			for x=0,3 do
				local inv = Inventory("type="..tostring(x))
				for i, item in pairs(inv) do
					if (item.id == atma.item) then
						haveClosest = true
					end
					if (haveClosest) then	
						break
					end
				end
				if (haveClosest) then
					break
				end
			end
			
			if (not haveClosest) then
				--We're already on the map with the most appropriate atma and we don't have it
				return false
			end
		end
	end
	
	--Third loop, figure out which ones we do have, then go anywhere else.
	for a, atma in pairs(ffxiv_task_grind.atmas) do
		local found = false
		for x=0,3 do
			local inv = Inventory("type="..tostring(x))
			for i, item in pairs(inv) do
				if (item.id == atma.item) then
					found = true
				end
				if (found) then	
					break
				end
			end
			if (found) then
				break
			end
		end
		
		if (not found) then
			e_nextatma.atma = atma
			return true
		end
	end
	
	return false
end
function e_nextatma:execute()
	local atma = e_nextatma.atma
	Player:Stop()
	Dismount()
	
	if (Player.ismounted) then
		return
	end
	
	if (ActionIsReady(7,5)) then
		Player:Teleport(atma.tele)
		ml_task_hub:ThisTask().correctMap = atma.map
		
		local newTask = ffxiv_task_teleport.Create()
		--d("Changing to new location for "..tostring(atma.name).." atma.")
		newTask.aetheryte = atma.tele
		newTask.mapID = atma.map
		ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
	end
end

--=======Avoidance============

c_avoid = inheritsFrom( ml_cause )
e_avoid = inheritsFrom( ml_effect )
e_avoid.lastAvoid = {}
c_avoid.newAvoid = {}
function c_avoid:evaluate()	
	if (gAvoidAOE == "0" or tonumber(gAvoidHP) == 0 or tonumber(gAvoidHP) < ml_global_information.Player_HP.percent) then
		return false
	end
	
	if (ml_task_hub:CurrentTask().name == "MOVETOPOS" or 
		ml_task_hub:CurrentTask().name == "MOVETOMAP" or
		ml_task_hub:CurrentTask().name == "MOVETOINTERACT") 
	then
		return false
	end
	
	--Reset tempvar.
	c_avoid.newAvoid = {}
	
	-- Check for nearby enemies casting things on us.
	local el = EntityList("aggro,incombat,onmesh,maxdistance=40")
	if (ValidTable(el)) then
		for i,e in pairs(el) do
			local shouldAvoid, spellData = AceLib.API.Avoidance.GetAvoidanceInfo(e)
			if (shouldAvoid and spellData) then
				local lastAvoid = c_avoid.lastAvoid
				if (lastAvoid) then
					if (spellData.id == lastAvoid.data.id and e.id == lastAvoid.attacker.id and Now() < lastAvoid.timer) then
						--d("Don't dodge, we already dodged this recently.")
						return false							
					end
				end
				
				--c_avoid.newAvoid = { timer = Now() + (castTime * 1000), spell = avoidableSpell, attacker = e, persistent = isPersistent }
				c_avoid.newAvoid = { timer = Now() + (spellData.castTime * 1000), data = spellData, attacker = e }
				return true
			end
		end
	end
	
	local el = EntityList("alive,incombat,attackable,onmesh,maxdistance=25")
	if (ValidTable(el)) then
		for i,e in pairs(el) do
			local shouldAvoid, spellData = AceLib.API.Avoidance.GetAvoidanceInfo(e)
			if (shouldAvoid and spellData) then
				local lastAvoid = c_avoid.lastAvoid
				if (lastAvoid) then
					if (spellData.id == lastAvoid.data.id and e.id == lastAvoid.attacker.id and Now() < lastAvoid.timer) then
						--d("Don't dodge, we already dodged this recently.")
						return false							
					end
				end
				
				--c_avoid.newAvoid = { timer = Now() + (castTime * 1000), spell = avoidableSpell, attacker = e, persistent = isPersistent }
				c_avoid.newAvoid = { timer = Now() + (spellData.castTime * 1000), data = spellData, attacker = e }
				return true
			end
		end
	end
	
	return false
end
function e_avoid:execute() 			
	local newPos,seconds,obstacle = AceLib.API.Avoidance.GetAvoidancePos(c_avoid.newAvoid)
	
	if (ValidTable(newPos)) then
		local ppos = ml_global_information.Player_Position
		local moveDist = PDistance3D(ppos.x,ppos.y,ppos.z,newPos.x,newPos.y,newPos.z)
		if (moveDist > 1.5) then
			if (ValidTable(obstacle)) then
				table.insert(ml_global_information.navObstacles,obstacle)
				d("Adding nav obstacle.")
			end
			c_avoid.lastAvoid = c_avoid.newAvoid
			local newTask = ffxiv_task_avoid.Create()
			newTask.pos = newPos
			newTask.targetid = c_avoid.newAvoid.attacker.id
			newTask.interruptCasting = true
			newTask.maxTime = seconds
			ml_task_hub:ThisTask().preserveSubtasks = true
			ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
		end
	else
		d("Can't dodge, didn't find a valid position.")
	end
end


c_autopotion = inheritsFrom( ml_cause )
e_autopotion = inheritsFrom( ml_effect )
c_autopotion.potions = "4554;4553;4552;4551"
c_autopotion.ethers = "4558;4557;4556;4555"
c_autopotion.itemid = 0
function c_autopotion:evaluate()
	if (Player.alive) then
		local potions = c_autopotion.potions
		if (tonumber(gPotionHP) > 0 and ml_global_information.Player_HP.percent < tonumber(gPotionHP)) then
			for itemid in StringSplit(potions,";") do
				if (ItemIsReady(tonumber(itemid))) then
					c_autopotion.itemid = tonumber(itemid)
					return true
				end
			end
		end
		
		local ethers = c_autopotion.ethers
		if (tonumber(gPotionMP) > 0 and ml_global_information.Player_MP.percent < tonumber(gPotionMP)) then
			for itemid in StringSplit(ethers,";") do
				if (ItemIsReady(tonumber(itemid))) then
					c_autopotion.itemid = tonumber(itemid)
					return true
				end
			end
		end
	end
	
	return false
end
function e_autopotion:execute()
	local newTask = ffxiv_task_useitem.Create()
	newTask.itemid = c_autopotion.itemid
	ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
end

---------------------------------------------------------------------------------------------
--ADD_MOVETOTARGET: If (current target distance > combat range) Then (add movetotarget task)
--Adds a MoveToTarget task 
---------------------------------------------------------------------------------------------
c_movetotarget = inheritsFrom( ml_cause )
e_movetotarget = inheritsFrom( ml_effect )
function c_movetotarget:evaluate()
	if ( not ml_task_hub:CurrentTask().canEngage ) then
		return false
	end
	
    if ( ml_task_hub:CurrentTask().targetid ~= nil and ml_task_hub:CurrentTask().targetid ~= 0 ) then
        local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
        if (target and target.id ~= 0 and target.alive) then
            return not InCombatRange(target.id)
        end
    end
    
    return false
end
function e_movetotarget:execute()
    ml_debug( "Moving within combat range of target" )
    local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
	local newTask = ffxiv_task_movetopos.Create()
	newTask.pos = target.pos
	newTask.targetid = target.id
	newTask.useFollowMovement = false
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_movecloser = inheritsFrom( ml_cause )
e_movecloser = inheritsFrom( ml_effect )
function c_movecloser:evaluate()
	if ( ml_task_hub:CurrentTask().targetid ~= nil and ml_task_hub:CurrentTask().targetid ~= 0 ) then
		local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
		if (target and target.id ~= 0 and target.alive) then
			return (target.distance > 40)
		end
	end
	
	return false
end
function e_movecloser:execute()
	local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
	local newTask = ffxiv_task_movetopos.Create()
	newTask.pos = target.pos
	newTask.targetid = target.id
	newTask.useFollowMovement = false
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_movetotargetsafe = inheritsFrom( ml_cause )
e_movetotargetsafe = inheritsFrom( ml_effect )
function c_movetotargetsafe:evaluate()
	if ( ml_task_hub:CurrentTask().canEngage ) then
		return false
	end
	
    if ( ml_task_hub:CurrentTask().targetid and ml_task_hub:CurrentTask().targetid ~= 0 ) then
        local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
        if (target and target.id ~= 0 and target.alive) then
			local tpos = target.pos
			local pos = ml_global_information.Player_Position
			if (Distance3D(tpos.x,tpos.y,tpos.z,pos.x,pos.y,pos.z) > (ml_task_hub:CurrentTask().safeDistance + 2)) then
				return true
			end
        end
    end
    
    return false
end
function e_movetotargetsafe:execute()
    local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
	local newTask = ffxiv_task_movetopos.Create()
	newTask.range = ml_task_hub:CurrentTask().safeDistance
	newTask.pos = target.pos
	newTask.targetid = target.id
	newTask.useFollowMovement = false
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

---------------------------------------------------------------------------------------------
--ADD_MOVETOMAP
--Adds a MoveToGate task 
---------------------------------------------------------------------------------------------
c_interactgate = inheritsFrom( ml_cause )
e_interactgate = inheritsFrom( ml_effect )
e_interactgate.timer = 0
e_interactgate.id = 0
e_interactgate.selector = 0
function c_interactgate:evaluate()
	if (ml_global_information.Player_IsLoading or ml_global_information.Player_IsLocked or ml_global_information.Player_IsCasting) then
		return false
	end
	
	e_interactgate.id = 0
	e_interactgate.selector = 0
	
    if (ml_task_hub:CurrentTask().destMapID) then
		if (ml_global_information.Player_Map ~= ml_task_hub:CurrentTask().destMapID) then
			local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position, 
														ml_global_information.Player_Map,	
														ml_task_hub:CurrentTask().destMapID	)

			if (ValidTable(pos) and pos.g) then				
				local interacts = EntityList("targetable,maxdistance=4,contentid="..tostring(pos.g))
				if (ValidTable(interacts)) then
					local i,interactable = next(interacts)
					if (i and interactable) then
						e_interactgate.id = interactable.id
						if (pos.i) then
							e_interactgate.selector = pos.i
						end
						return true
					end
				end
			end
		end
	end
	
	return false
end
function e_interactgate:execute()
	if (Now() < e_interactgate.timer) then
		return false
	end
	
	if (ml_global_information.Player_IsMoving) then
		Player:Stop()
	end
	
	if (ControlVisible("SelectString") or ControlVisible("SelectIconString")) then
		local selector = e_interactgate.selector
		SelectConversationIndex(selector)
		e_interactgate.timer = Now() + 1500
		return
	end
	
	local gate = EntityList:Get(e_interactgate.id)
	local pos = gate.pos
	SetFacing(pos.x,pos.y,pos.z)
	Player:Interact(gate.id)
	e_interactgate.timer = Now() + 1500
end

c_transportgate = inheritsFrom( ml_cause )
e_transportgate = inheritsFrom( ml_effect )
e_transportgate.details = nil
function c_transportgate:evaluate()
	if (ml_global_information.Player_IsLoading or ml_global_information.Player_IsLocked or ml_global_information.Player_IsCasting) then
		return false
	end
	
	if (ml_task_hub:ThisTask().destMapID) then
		if (ml_global_information.Player_Map ~= ml_task_hub:CurrentTask().destMapID) then
			local pos = ml_nav_manager.GetNextPathPos( 	ml_global_information.Player_Position,	
														ml_global_information.Player_Map,	
														ml_task_hub:CurrentTask().destMapID	)
			
			if (ValidTable(pos)) then
				if (not c_usenavinteraction:evaluate(pos)) then
					if (ValidTable(pos) and pos.b) then
						local details = {}
						details.uniqueid = pos.b
						details.pos = { x = pos.x, y = pos.y, z = pos.z }
						details.conversationIndex = pos.i or 0
						e_transportgate.details = details
						return true
					elseif (ValidTable(pos) and pos.a) then
						local details = {}
						details.uniqueid = pos.a
						details.pos = { x = pos.x, y = pos.y, z = pos.z }
						details.conversationIndex = pos.i or 0
						e_transportgate.details = details
						return true
					end
				end
			end
		end
	end
	
	return false
end
function e_transportgate:execute()
	local gateDetails = e_transportgate.details
	local newTask = ffxiv_nav_interact.Create()
	if (gTeleport == "1") then
		newTask.useTeleport = true
	end
	newTask.destMapID = ml_task_hub:CurrentTask().destMapID
	newTask.pos = gateDetails.pos
	newTask.uniqueid = gateDetails.uniqueid
	newTask.conversationIndex = gateDetails.conversationIndex
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_movetogate = inheritsFrom( ml_cause )
e_movetogate = inheritsFrom( ml_effect )
e_movetogate.pos = {}
function c_movetogate:evaluate()
	if (ml_global_information.Player_IsLoading or 
		(ml_global_information.Player_IsLocked and not IsFlying()) or 
		ml_global_information.Player_IsCasting or
		ml_global_information.Player_Map == 0) 
	then
		return false
	end
	
	e_movetogate.pos = {}
	
    if (ml_task_hub:CurrentTask().destMapID and (ml_global_information.Player_Map ~= ml_task_hub:CurrentTask().destMapID)) then
        local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position,
													ml_global_information.Player_Map,
													ml_task_hub:CurrentTask().destMapID	)
		if (ValidTable(pos)) then
			e_movetogate.pos = pos
			return true
		else
			local backupPos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position,
																ml_global_information.Player_Map,
																155	)
			if (ValidTable(backupPos)) then
				ml_task_hub:CurrentTask().destMapID = 155
				e_movetogate.pos = backupPos
				return true
			end
		end
	end
	
	return false
end
function e_movetogate:execute()
	local pos = e_movetogate.pos
	
	local mapid = ml_task_hub:CurrentTask().destMapID
	if (mapid == 399 and ml_global_information.Player_Map == 478) then
		local destPos = ml_task_hub:CurrentTask().pos
		if (ValidTable(destPos)) then
			if (GetHinterlandsSection(destPos) == 1) then
				d("Destination is hinterlands section 1.")
				pos = {x = 73.259323120117, y = 205, z = 143.04707336426, h = -0.52216768264771}
			else
				d("Destination is hinterlands section 2.")
				pos = {x = 147.0463, y = 207, z = 115.8594, h = 0.9793}
			end
		end
	end
	
	local newTask = ffxiv_task_movetopos.Create()
	newTask.use3d = false
	newTask.pos = pos
	local newPos = { x = pos.x, y = pos.y, z = pos.z }
	local newPos = GetPosFromDistanceHeading(newPos, 5, pos.h)
	
	if (not e_movetogate.pos.g and not e_movetogate.pos.b and not e_movetogate.pos.a) then
		newTask.gatePos = newPos
	end
	
	newTask.range = 0.5
	newTask.remainMounted = true
	newTask.ignoreAggro = true
	newTask.destMapID = ml_task_hub:CurrentTask().destMapID
	if (gTeleport == "1") then
		newTask.useTeleport = true
	end
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_leavelockedarea = inheritsFrom( ml_cause )
e_leavelockedarea = inheritsFrom( ml_effect )
e_leavelockedarea.map = 0
function c_leavelockedarea:evaluate()
	if (ml_global_information.Player_IsLoading or ml_global_information.Player_IsLocked or ml_global_information.Player_IsCasting) then
		return false
	end
	
	e_leavelockedarea.map = 0
	
    if (ml_task_hub:CurrentTask().destMapID and (ml_global_information.Player_Map ~= ml_task_hub:CurrentTask().destMapID)) then
        local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position,
													ml_global_information.Player_Map,
													ml_task_hub:CurrentTask().destMapID	)
		if (not ValidTable(pos)) then
			-- No valid path forward, set a new destination for the nearest map.
			local currNode = ml_nav_manager.GetNode(ml_global_information.Player_Map)
			if (ValidTable(currNode)) then
				local neighbors = currNode:ValidNeighbors()
				if (ValidTable(neighbors)) then
					local nearest = nil
					local nearestDistance = math.huge
					local ppos = ml_global_information.Player_Position
					
					for id,entries in pairs(neighbors) do
						for _,gate in pairs(entries) do
							local dist = PDistance3D(ppos.x,ppos.y,ppos.z,gate.x,gate.y,gate.z)
							if (not nearest or (nearest and dist < nearestDistance)) then
								nearest = id
								nearestDistance = dist
							end
						end
					end
					
					if (nearest) then
						e_leavelockedarea.map = nearest
					end
				end
			end
		end
	end
end
function e_leavelockedarea:execute()
	ml_task_hub:CurrentTask().destMapID = e_leavelockedarea.map
end

c_teleporttomap = inheritsFrom( ml_cause )
e_teleporttomap = inheritsFrom( ml_effect )
e_teleporttomap.aeth = nil
function c_teleporttomap:evaluate()
	if (ml_global_information.Player_IsLoading or 
		(ml_global_information.Player_IsLocked and not IsFlying()) or 
		ml_global_information.Player_IsCasting or GilCount() < 1500 or
		IsNull(ml_task_hub:ThisTask().destMapID,0) == 0 or
		IsNull(ml_task_hub:ThisTask().destMapID,0) == ml_global_information.Player_Map) 
	then
		ml_debug("Cannot use teleport, position is locked, or we are casting, or our gil count is less than 1500.")
		return false
	end
	
	e_teleporttomap.aeth = nil
	
	local el = EntityList("alive,attackable,onmesh,aggro")
	if (ValidTable(el)) then
		ml_debug("Cannot use teleport, we have aggro currently.")
		return false
	end
	
	--Only perform this check when dismounted.
	local teleport = ActionList:Get(7,5)
	if (not teleport or not teleport.isready or ml_global_information.Player_Casting.channelingid == 5) then
		ml_debug("Cannot use teleport, the spell is not ready or we are already casting it.")
		return false
	end
	
	local noTeleportMaps = { [177] = true, [178] = true, [179] = true }
	if (noTeleportMaps[ml_global_information.Player_Map]) then
		return false
	end
	
	local destMapID = ml_task_hub:ThisTask().destMapID
    if (destMapID) then
        local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position,
                                                    ml_global_information.Player_Map,
                                                    destMapID	)
		if (ValidTable(pos)) then
			local ppos = ml_global_information.Player_Position
			local dist = PDistance3D(ppos.x,ppos.y,ppos.z,pos.x,pos.y,pos.z)
			
			if (ValidTable(ml_nav_manager.currPath) and (TableSize(ml_nav_manager.currPath) > 2 or (TableSize(ml_nav_manager.currPath) <= 2 and dist > 120))) then
				
				local aeth = GetAetheryteByMapID(destMapID, ml_task_hub:ThisTask().pos)
				if (aeth) then
					e_teleporttomap.aeth = aeth
					return true
				end
				
				local lastAeth = nil
				for _, node in pairsByKeys(ml_nav_manager.currPath) do
					if (node.id ~= ml_global_information.Player_Map) then
						local aeth = GetAetheryteByMapID(node.id)
						if (aeth) then
							lastAeth = aeth
						end
					end
				end
				
				if (lastAeth ~= nil) then
					e_teleporttomap.aeth = lastAeth
					return true
				end
			end
		else
			--d("Attempting to find aetheryte for mapid ["..tostring(destMapID).."].")
			local aeth = GetAetheryteByMapID(destMapID, ml_task_hub:ThisTask().pos)
			if (aeth) then
				e_teleporttomap.aeth = aeth
				return true
			end
			
			local attunedAetherytes = GetAttunedAetheryteList()
			-- Fall back check to see if we can get to Foundation, and from there to the destination.
			for k,aetheryte in pairs(attunedAetherytes) do
				if (aetheryte.id == 70 and GilCount() >= aetheryte.price) then
					local aethPos = {x = -68.819107055664, y = 8.1133041381836, z = 46.482696533203}
					local backupPos = ml_nav_manager.GetNextPathPos(aethPos,418,destMapID)
					if (ValidTable(backupPos)) then
						e_teleporttomap.aeth = aetheryte
						return true
					end
				end
			end
		end
	else
		ml_debug("Cannot use teleport, no destination map ID was provided.")
    end
    
    return false
end
function e_teleporttomap:execute()
	if (ml_global_information.Player_IsMoving) then
		Player:Stop()
		return
	end
	
	if (ActionIsReady(7,5)) then
		if (Player:Teleport(e_teleporttomap.aeth.id)) then	
			
			if (ml_task_hub:CurrentTask().name ~= "MOVETOMAP") then
				ml_task_hub:CurrentTask().completed = true
			end
		
			local newTask = ffxiv_task_teleport.Create()
			newTask.setHomepoint = ml_task_hub:ThisTask().setHomepoint
			newTask.aetheryte = e_teleporttomap.aeth.id
			newTask.mapID = e_teleporttomap.aeth.territory
			ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
		end
	end
end

c_followleader = inheritsFrom( ml_cause )
e_followleader = inheritsFrom( ml_effect )
c_followleader.range = math.random(3,8)
c_followleader.leaderpos = nil
c_followleader.leader = nil
c_followleader.distance = nil
c_followleader.hasEntity = false
e_followleader.isFollowing = false
e_followleader.stopFollow = false
function c_followleader:evaluate()
	if (gBotMode == GetString("partyMode") and IsLeader() or ml_global_information.Player_IsCasting) then
        return false
    end
	
	local leader, isEntity = GetPartyLeader()
	local leaderPos = GetPartyLeaderPos()
	if (ValidTable(leaderPos) and ValidTable(leader)) then
		local myPos = ml_global_information.Player_Position	
		local distance = PDistance3D(myPos.x, myPos.y, myPos.z, leaderPos.x, leaderPos.y, leaderPos.z)
		
		if (((leader.incombat and distance > 5) or (distance > 10)) or (isEntity and (leader.ismounted and not Player.ismounted))) then				
			c_followleader.leaderpos = leaderPos
			c_followleader.leader = leader
			c_followleader.distance = distance
			c_followleader.hasEntity = isEntity
			return true
		end
	end
	
	if (e_followleader.isFollowing) then
		e_followleader.stopFollow = true
		return true
	end
	
    return false
end

function e_followleader:execute()
	local leader = c_followleader.leader
	local leaderPos = c_followleader.leaderpos
	local distance = c_followleader.distance
	
	if (e_followleader.isFollowing and e_followleader.stopFollow) then
		Player:Stop()
		e_followleader.isFollowing = false
		e_followleader.stopFollow = false
		return
	end
	
	if (Player.onmesh) then		
		-- mount
		
		if (gUseMount == "1" and gMount ~= "None" and c_followleader.hasEntity) then
			if (((leader.castinginfo.channelingid == 4 or leader.ismounted) or distance >= tonumber(gMountDist)) and not Player.ismounted) then
				if (not ml_global_information.Player_IsCasting) then
					Player:Stop()
					Mount()
				end
				return
			end
		end
		
		--sprint
		if (gUseSprint == "1" and distance >= tonumber(gSprintDist)) then
			if ( not HasBuff(Player.id, 50) and not Player.ismounted) then
				local sprint = ActionList:Get(3)
				if (sprint.isready) then	
					sprint:Cast()
				end
			end
		end
		
		if (gTeleport == "1") then
			if (distance > 100) then
				GameHacks:TeleportToXYZ(leaderPos.x,leaderPos.y,leaderPos.z)
				Player:SetFacingSynced(leaderPos.x,leaderPos.y,leaderPos.z)
			end
		end
		
		if (c_followleader.hasEntity and leader.los) then
			ml_debug( "Moving to Leader: "..tostring(Player:MoveTo(leaderPos.x, leaderPos.y, leaderPos.z, tonumber(c_followleader.range),true,false)))	
		else
			ml_debug( "Moving to Leader: "..tostring(Player:MoveTo(leaderPos.x, leaderPos.y, leaderPos.z, tonumber(c_followleader.range),false,false)))	
		end
		if ( not ml_global_information.Player_IsMoving) then
			if ( ml_global_information.AttackRange < 5 ) then
				c_followleader.range = math.random(4,6)
			else
				c_followleader.range = math.random(6,10)
			end
		end
		e_followleader.isFollowing = true
	else
		if ( not ml_global_information.Player_IsMoving ) then
			FollowResult = Player:FollowTarget(leader.id)
			ml_debug( "Following Leader: "..tostring(FollowResult))
		end
	end
end

---------------------------------------------------------------------------------------------
--Task Completion CNEs
--These are cnes which are added to the process element list for a task and exist only to
--complete the specified task. They should be specific to the task which contains them...
--their only purpose should be to check the current game state and adjust the behavior of 
--the task in order to ensure its completion. 
---------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
--WALKTOPOS: If (distance to target > task.range) Then (move to pos)
---------------------------------------------------------------------------------------------
c_walktopos = inheritsFrom( ml_cause )
e_walktopos = inheritsFrom( ml_effect )
c_walktopos.pos = 0
e_walktopos.lastRun = 0
e_walktopos.lastPath = 0
e_walktopos.lastFail = 0
e_walktopos.lastStealth = 0
c_walktopos.lastPos = {}
function c_walktopos:evaluate()
	if ((ml_global_information.Player_IsLocked and not IsFlying()) or 
		ml_global_information.Player_IsLoading or
		IsMounting() or 
		ControlVisible("SelectString") or ControlVisible("SelectIconString") or 
		IsShopWindowOpen() or
		(ml_global_information.Player_IsCasting and not IsNull(ml_task_hub:CurrentTask().interruptCasting,false))) 
	then
		return false
	end
	
    if (ValidTable(ml_task_hub:CurrentTask().pos) or ValidTable(ml_task_hub:CurrentTask().gatePos)) then		
		local myPos = ml_global_information.Player_Position
		local gotoPos = nil
		if (ml_task_hub:CurrentTask().gatePos) then
			gotoPos = ml_task_hub:CurrentTask().gatePos
			--ml_debug("[c_walktopos]: Position adjusted to gate position.", "gLogCNE", 2)
		else
			gotoPos = ml_task_hub:CurrentTask().pos
			local p,dist = NavigationManager:GetClosestPointOnMesh(gotoPos)
			if (p and dist > 2) then
				--ml_debug("[c_walktopos]: Position adjusted to closest mesh point.", "gLogCNE", 2)
				gotoPos = p
			end
			--ml_debug("[c_walktopos]: Position left as original position.", "gLogCNE", 2)
		end
		
		if (ValidTable(gotoPos)) then
			local range = ml_task_hub:CurrentTask().range or 0
			if (range > 0) then
				local distance = 0.0
				if (ml_task_hub:CurrentTask().use3d) then
					distance = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
				else
					distance = Distance2D(myPos.x, myPos.z, gotoPos.x, gotoPos.z)
				end
			
				if (distance > ml_task_hub:CurrentTask().range) then
					c_walktopos.pos = gotoPos
					return true
				end
			else
				c_walktopos.pos = gotoPos
				return true
			end
		end
    end
    return false
end
function e_walktopos:execute()
	if (IsGatherer(Player.job) or IsFisher(Player.job)) then
		local needsStealth = ml_global_information.needsStealth
		local hasStealth = HasBuff(Player.id,47)
		if (not hasStealth and needsStealth) then
			if (Player.action ~= 367 and TimeSince(e_walktopos.lastStealth) > 1200) then
				local newTask = ffxiv_task_stealth.Create()
				newTask.addingStealth = true
				ml_task_hub:Add(newTask, REACTIVE_GOAL, TP_IMMEDIATE)
				e_walktopos.lastStealth = Now()
				--d("adding stealth.")
				return
			end
		elseif (hasStealth and not needsStealth) then
			if (Player.action ~= 367 and TimeSince(e_walktopos.lastStealth) > 1200) then
				local newTask = ffxiv_task_stealth.Create()
				newTask.droppingStealth = true
				ml_task_hub:Add(newTask, REACTIVE_GOAL, TP_IMMEDIATE)
				e_walktopos.lastStealth = Now()
				--d("dropping stealth.")
				return
			end
		end
	end
	
	if (ValidTable(c_walktopos.pos)) then
		local gotoPos = c_walktopos.pos
		local myPos = ml_global_information.Player_Position
		
		if (false) then
			if (ValidTable(c_walktopos.lastPos) and IsFlying()) then
				local lastPos = c_walktopos.lastPos
				--d("Checking if last wanted position was the same position.")
				local dist = PDistance3D(lastPos.x, lastPos.y, lastPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
				if (dist < 1) then
					if ((TimeSince(e_walktopos.lastPath) < 10000 and Player:IsMoving()) or
						(TimeSince(e_walktopos.lastPath) < 1000 and not Player:IsMoving()) or
						(TimeSince(e_walktopos.lastFail) < 10000)) 
					then
						--d("Blocked execution since we should already be en route.")
						return
					end
				else
					--d("distance is greater than 1 ["..tostring(dist).."], allow it.")
				end
			end
		end
		
		ml_debug("[e_walktopos]: Position = { x = "..tostring(gotoPos.x)..", y = "..tostring(gotoPos.y)..", z = "..tostring(gotoPos.z).."}", "gLogCNE", 2)
		
		local dist = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
		if (dist > 2) then
		
			ml_debug("[e_walktopos]: Hit MoveTo..", "gLogCNE", 2)
			local path = Player:MoveTo(tonumber(gotoPos.x),tonumber(gotoPos.y),tonumber(gotoPos.z),2,ml_task_hub:CurrentTask().useFollowMovement or false,gRandomPaths=="1",ml_task_hub:CurrentTask().useSmoothTurns or false)
			
			c_walktopos.lastPos = gotoPos
			if (not tonumber(path)) then
				ml_debug("[e_walktopos]: An error occurred in creating the path.", "gLogCNE", 2)
				if (path ~= nil) then
					ml_debug(path)
				end
				Player:Stop()
				e_walktopos.lastFail = Now()
			elseif (path >= 0) then
				ml_debug("[e_walktopos]: A path with ["..tostring(path).."] points was created.", "gLogCNE", 2)
				e_walktopos.lastPath = Now()
				return
			elseif (path <= -1) then
				ml_debug("[e_walktopos]: A path could not be created towards the goal, error code ["..tostring(path).."].", "gLogCNE", 2)
				Player:Stop()
				e_walktopos.lastFail = Now()
			end
		else
			--d("We are very close, make sure we aren't flying.")
			if (not IsFlying()) then
				Player:SetFacing(gotoPos.x,gotoPos.y,gotoPos.z)
				if (not ml_global_information.Player_IsMoving) then
					Player:Move(FFXIV.MOVEMENT.FORWARD)
					e_walktopos.lastRun = Now()
				end
			end
		end
	end
	c_walktopos.pos = 0
end

c_avoidaggressives = inheritsFrom( ml_cause )
e_avoidaggressives = inheritsFrom( ml_effect )
e_avoidaggressives.timer = 0
function c_avoidaggressives:evaluate()
	if (Now() < e_avoidaggressives.timer or IsFlying()) then
		return false
	end
	
	local needsUpdate = false
	
	local aggressives = EntityList("alive,attackable,aggressive,minlevel="..tostring(Player.level - 10)..",maxdistance=50")
	if (ValidTable(aggressives)) then
		local avoidanceAreas = ml_global_information.avoidanceAreas
		for i,entity in pairs(aggressives) do
			local hasEntry = false
			for i,area in pairs(avoidanceAreas) do
				if (area.id == entity.id and area.expiration > Now()) then
					hasEntry = true
				end
			end
			
			if (not hasEntry) then
				--d("Setting avoidance area for ["..tostring(entity.name).."].")
				local newArea = { id = entity.id, x = entity.pos.x, y = entity.pos.y, z = entity.pos.z, level = entity.level, r = 10, expiration = Now() + 5000, source = "c_avoidaggressives" }
				table.insert(avoidanceAreas,newArea)
				needsUpdate = true
			end
		end		
	else
		local avoidanceAreas = ml_global_information.avoidanceAreas
		if (ValidTable(avoidanceAreas)) then
			for i,area in pairs(avoidanceAreas) do
				if (area.source == "c_avoidaggressives") then
					if (TableSize(avoidanceAreas) > 1) then
						table.remove(avoidanceAreas,i)
						needsUpdate = true
					else
						ml_global_information.avoidanceAreas = {}
						needsUpdate = true
						break
					end
				end
			end
		end
	end
	
	if (needsUpdate) then
		local avoidanceAreas = ml_global_information.avoidanceAreas
		if (ValidTable(avoidanceAreas)) then
			--d("Setting avoidance areas.")
			NavigationManager:SetAvoidanceAreas(avoidanceAreas)
		else
			NavigationManager:ClearAvoidanceAreas()
		end
		return true
	end
	
	return false
end
function e_avoidaggressives:execute()
	e_avoidaggressives.timer = Now() + 2000
	ml_task_hub:ThisTask().preserveSubtasks = true
end


c_usenavinteraction = inheritsFrom( ml_cause )
e_usenavinteraction = inheritsFrom( ml_effect )
c_usenavinteraction.blockOnly = false
e_usenavinteraction.task = nil
e_usenavinteraction.timer = 0
function c_usenavinteraction:evaluate(pos)
	local gotoPos = pos or ml_task_hub:ThisTask().pos
	
	e_usenavinteraction.task = nil
	c_usenavinteraction.blockOnly = false
	
	if (not ValidTable(gotoPos)) then
		return false
	end
	
	local transportFunction = _G["Transport"..tostring(ml_global_information.Player_Map)]
	if (transportFunction ~= nil and type(transportFunction) == "function") then
		local retval,task = transportFunction(ml_global_information.Player_Position,gotoPos)
		if (retval == true) then
			e_usenavinteraction.task = task
			return true
		end
	end
	
	--[[local requiresTransport = ml_global_information.requiresTransport
	if (requiresTransport[ml_global_information.Player_Map]) then
		e_usenavinteraction.task = requiresTransport[ml_global_information.Player_Map].reaction
		return requiresTransport[ml_global_information.Player_Map].test()
	end--]]
	
	return false
end
function e_usenavinteraction:execute()
	if (ml_global_information.Player_IsCasting or Now() < e_usenavinteraction.timer or c_usenavinteraction.blockOnly) then
		return false
	end
	
	e_usenavinteraction.task()
	e_usenavinteraction.timer = Now() + 2000
end

-- Checks for a better target while we are engaged in fighting an enemy and switches to it
c_bettertargetsearch = inheritsFrom( ml_cause )
e_bettertargetsearch = inheritsFrom( ml_effect )
c_bettertargetsearch.targetid = 0
function c_bettertargetsearch:evaluate()        
    if (gBotMode == GetString("partyMode") and not IsLeader()) then
        return false
    end
	
	if (gBotMode == GetString("huntMode") or gBotMode == GetString("questMode")) then
		return false
	end
	
	if (ml_global_information.Player_IsCasting or Now() < c_add_killtarget.oocCastTimer) then
		return false
	end
    
	if (ml_task_hub:CurrentTask().name == "LT_KILLTARGET" and ml_task_hub:RootTask().name == "LT_GRIND") then
		if (not ml_global_information.Player_InCombat) then
			local bettertarget = GetNearestGrindAttackable()
			if ( bettertarget ~= nil and bettertarget.id ~= ml_task_hub:CurrentTask().targetid ) then
				c_bettertargetsearch.targetid = bettertarget.id
				return true                        
			end
		end
	elseif (ml_task_hub:CurrentTask().name == "LT_SM_KILLTARGET" and gClaimFirst == "1") then
		local bettertarget = GetNearestGrindPriority()
		if ( bettertarget ~= nil and bettertarget.id ~= ml_task_hub:CurrentTask().targetid ) then
			c_bettertargetsearch.targetid = bettertarget.id
			return true                      
		end
	end
     
    return false
end
function e_bettertargetsearch:execute()
    ml_task_hub:CurrentTask().targetid = c_bettertargetsearch.targetid
	Player:SetTarget(c_bettertargetsearch.targetid)        
end

-----------------------------------------------------------------------------------------------
--MOUNT: If (distance to pos > ? or < ?) Then (mount or unmount)
---------------------------------------------------------------------------------------------
c_mount = inheritsFrom( ml_cause )
e_mount = inheritsFrom( ml_effect )
e_mount.id = 0
e_mount.lastPathCheck = 0
e_mount.lastPathPos = {}
function c_mount:evaluate()
	if (ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or ControlVisible("SelectString") or ControlVisible("SelectIconString") 
		or IsShopWindowOpen() or Player.ismounted or ml_global_information.Player_InCombat or IsFlying()) 
	then
		return false
	end
	
	if (IsMounting()) then
		return true
	end
	
	noMountMaps = {
		[130] = true,[131] = true,[132] = true,[133] = true,[128] = true,[129] = true,[144] = true,
		[337] = true,[336] = true,[175] = true,[352] = true,[418] = true,[419] = true,
	}
	
    if (noMountMaps[ml_global_information.Player_Map]) then
		return false
	end
	
	if (HasBuffs(Player,"47") and ml_global_information.needsStealth) then
		return false
	end
	
	e_mount.id = 0
	
    if ( ml_task_hub:CurrentTask().pos ~= nil and ml_task_hub:CurrentTask().pos ~= 0) then
		local myPos = ml_global_information.Player_Position
		local gotoPos = ml_task_hub:CurrentTask().pos
		local lastPos = e_mount.lastPathPos
		
		-- If we change our gotoPos or have never measured it, reset the watch.
		if (ValidTable(lastPos)) then
			if (PDistance3D(lastPos.x, lastPos.y, lastPos.z, gotoPos.x, gotoPos.y, gotoPos.z) > 1) then
				e_mount.lastPathPos = gotoPos
				e_mount.lastPathCheck = 0
			end
		end
		
		local distance = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
		
		local forcemount = false
		if (CanFlyInZone()) then
			if (not Player:IsMoving() or TimeSince(e_mount.lastPathCheck) > 5000) then
				local path = NavigationManager:GetPath(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
				local pathsize = TableSize(path)
				if (pathsize > 0) then
					if (ValidTable(path)) then
						local lasthop = path[pathsize-1]
						if (lasthop) then
							local goaltohop = PDistance3D(lasthop.x, lasthop.y, lasthop.z, gotoPos.x, gotoPos.y, gotoPos.z)
							if (goaltohop > 5) then
								forcemount = true
							end
						end
					end
				end
				
				e_mount.lastPathCheck = Now()
			end
		end

		if ((distance > tonumber(gMountDist)) or forcemount) then
			--Added mount verifications here.
			--Realistically, the GUIVarUpdates should handle this, but just in case, we backup check it here.
			local mountID
			local mountIndex
			local mountlist = ActionList("type=13")
			
			if (ValidTable(mountlist)) then
				--First pass, look for our named mount.
				for k,v in pairsByKeys(mountlist) do
					if (v.name == gMount) then
						local acMount = ActionList:Get(v.id,13)
						if (acMount and acMount.isready) then
							e_mount.id = v.id
							return true
						end
					end
				end
				
				--Second pass, look for any mount as backup.
				if (gMount == GetString("none")) then
					for k,v in pairsByKeys(mountlist) do
						local acMount = ActionList:Get(v.id,13)
						if (acMount and acMount.isready) then
							SetGUIVar("gMount", v.name)
							e_mount.id = v.id
							return true
						end
					end		
				end
			end
		end
    end
    
    return false
end
function e_mount:execute()
	if (Player:IsMoving()) then
		Player:Stop()
		--d("Stopped.")
		return
	end
	
	if (IsMounting() or UsingBattleItem()) then
		--d("Adding a wait.")
		ml_task_hub:CurrentTask():SetDelay(2000)
		return
	end
	
    Mount(e_mount.id)
	--d("Set a delay for 500")
	ml_task_hub:CurrentTask():SetDelay(500)
end

c_battlemount = inheritsFrom( ml_cause )
e_battlemount = inheritsFrom( ml_effect )
e_battlemount.id = 0
function c_battlemount:evaluate()
	if (ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or ControlVisible("SelectString") or ControlVisible("SelectIconString") 
		or IsShopWindowOpen() or Player.ismounted or ml_global_information.Player_InCombat or IsFlying()) 
	then
		return false
	end
	
	if (IsMounting()) then
		return true
	end
	
	noMountMaps = {
		[130] = true,[131] = true,[132] = true,[133] = true,[128] = true,[129] = true,[144] = true,
		[337] = true,[336] = true,[175] = true,[352] = true,[418] = true,[419] = true,
	}
	
    if (noMountMaps[ml_global_information.Player_Map]) then
		return false
	end
	
	if (HasBuffs(Player,"47") and ml_global_information.needsStealth) then
		return false
	end
	
	e_battlemount.id = 0
	
    if ( ml_task_hub:CurrentTask().pos ~= nil and ml_task_hub:CurrentTask().pos ~= 0 and gUseMount == "1") then
		local myPos = ml_global_information.Player_Position
		local gotoPos = ml_task_hub:CurrentTask().pos
		local distance = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
	
		if (distance > tonumber(gMountDist)) then
			--Added mount verifications here.
			--Realistically, the GUIVarUpdates should handle this, but just in case, we backup check it here.
			local mountID
			local mountIndex
			local mountlist = ActionList("type=13")
			
			if (ValidTable(mountlist)) then
				--First pass, look for our named mount.
				for k,v in pairsByKeys(mountlist) do
					if (v.name == gMount) then
						local acMount = ActionList:Get(v.id,13)
						if (acMount and acMount.isready) then
							e_battlemount.id = v.id
							return true
						end
					end
				end
				
				--Second pass, look for any mount as backup.
				if (gMount == GetString("none")) then
					for k,v in pairsByKeys(mountlist) do
						local acMount = ActionList:Get(v.id,13)
						if (acMount and acMount.isready) then
							SetGUIVar("gMount", v.name)
							e_battlemount.id = v.id
							return true
						end
					end		
				end
			end
		end
    end
    
    return false
end
function e_battlemount:execute()
	if (Player:IsMoving()) then
		Player:Stop()
		--d("Stopped.")
		return
	end
	
	if (IsMounting() or UsingBattleItem()) then
		--d("Adding a wait.")
		ml_task_hub:CurrentTask():SetDelay(2000)
		return
	end
	
    Mount(e_battlemount.id)
	--d("Set a delay for 500")
	ml_task_hub:CurrentTask():SetDelay(500)
end

c_battleitem = inheritsFrom( ml_cause )
e_battleitem = inheritsFrom( ml_effect )
function c_battleitem:evaluate()
	return UsingBattleItem()
end
function e_battleitem:execute()
	--Do nothing, just block execution of other stuff.
end

c_companion = inheritsFrom( ml_cause )
e_companion = inheritsFrom( ml_effect )
e_companion.lastSummon = 0
e_companion.blockOnly = false
function c_companion:evaluate()
	--Reset tempvar.
	e_companion.blockOnly = false
	
	if (ml_global_information.Player_Casting.channelingid == 4868) then
		e_companion.blockOnly = true
		return true
	end
	
	if (ffxiv_task_quest.noCompanion == true) then
		return false
	end
	
    if (gBotMode == GetString("pvpMode") or 
		TimeSince(e_companion.lastSummon) < 4000 or
		Player.ismounted or IsMounting() or IsDismounting() or
		IsCompanionSummoned()) 
	then
        return false
    end

    if ((gChocoGrind == "1" and (gBotMode == GetString("grindMode") or gBotMode == GetString("partyMode"))) or
		(gChocoAssist == "1" and gBotMode == GetString("assistMode")) or
		(gChocoQuest == "1" and gBotMode == GetString("questMode"))) 
	then	
		local item = Inventory:Get(4868)
		if (ValidTable(item) and item.isready) then
			return true
		end
    end
	
    return false
end

function e_companion:execute()
	if (e_companion.blockOnly) then
		return
	end
	
	Player:Stop()
	e_companion.lastSummon = Now()
	local item = Inventory:Get(4868)
	item:Use()
	
	ml_task_hub:CurrentTask():SetDelay(2000)
	ml_task_hub:ThisTask().preserveSubtasks = true
end

c_stance = inheritsFrom( ml_cause )
e_stance = inheritsFrom( ml_effect )
function c_stance:evaluate()
	if (IsCompanionSummoned() and ValidString(gChocoStance)) then
		
		if (TimeSince(ml_global_information.stanceTimer) >= 30000) then
			local stanceAction = ml_global_information.chocoStance[gChocoStance]
			if (stanceAction) then
				local acStance = ActionList:Get(stanceAction,6)		
				if (acStance and acStance.isready) then
					acStance:Cast(Player.id)
					return true
				end
			end
		end
	end
    
    return false
end

function e_stance:execute()
	ml_global_information.stanceTimer = Now()
	ml_task_hub:ThisTask().preserveSubtasks = true
end

-----------------------------------------------------------------------------------------------
--SPRINT: If (distance to pos > ? or < ?) Then (mount or unmount)
---------------------------------------------------------------------------------------------
c_sprint = inheritsFrom( ml_cause )
e_sprint = inheritsFrom( ml_effect )
function c_sprint:evaluate()
    if (gBotMode == "PVP") then
        return false
    end
	
	if (ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or IsMounting() or ControlVisible("SelectString") or ControlVisible("SelectIconString") or IsShopWindowOpen() or Player.ismounted) then
		return false
	end

    if (not HasBuff(Player.id, 50) and ml_global_information.Player_IsMoving) then
		if (IsCityMap(ml_global_information.Player_Map) or gUseSprint == "1") then
			if ( ml_task_hub:CurrentTask().pos ~= nil and ml_task_hub:CurrentTask().pos ~= 0) then
				local myPos = ml_global_information.Player_Position
				local gotoPos = ml_task_hub:CurrentTask().pos
				local distance = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
				
				if (distance > tonumber(gSprintDist)) then	
					local sprint = ActionList:Get(3)
					if (sprint and sprint.isready) then
						return true
					end
				end
			end
		end
    end
    
    return false
end
function e_sprint:execute()
    local sprint = ActionList:Get(3)
	if (sprint and sprint.isready) then
		sprint:Cast()
	end
end

--minor abuse of the cne system here to update target pos
c_updatetarget = inheritsFrom( ml_cause )
e_updatetarget = inheritsFrom( ml_effect )
function c_updatetarget:evaluate()	
    if (ml_task_hub:ThisTask().targetid~=nil and ml_task_hub:ThisTask().targetid~=0)then
        local target = EntityList:Get(ml_task_hub.ThisTask().targetid)
        if (target ~= nil) then
            if (target.alive and target.attackable) then
                if (ml_task_hub:CurrentTask().name == "MOVETOPOS" ) then
					e_updatetarget.pos = target.pos				
                end
				return false
            end
        end
    end	
end
function e_updatetarget:execute()
end

c_attarget = inheritsFrom( ml_cause )
e_attarget = inheritsFrom( ml_effect )
function c_attarget:evaluate()
    if (ml_task_hub:CurrentTask().name == "MOVETOPOS") then
        if ml_global_information.AttackRange > 20 then
            local target = EntityList:Get(ml_task_hub:ThisTask().targetid)
            if ValidTable(target) then
                local rangePercent = tonumber(gCombatRangePercent) * 0.01
                return InCombatRange(ml_task_hub:ThisTask().targetid) and target.distance2d < (ml_global_information.AttackRange * rangePercent)
            end
        else
            return InCombatRange(ml_task_hub:ThisTask().targetid)
        end
    end
    return false
end
function e_attarget:execute()
    Player:Stop()
    ml_task_hub:CurrentTask():task_complete_execute()
    ml_task_hub:CurrentTask():Terminate()
end

---------------------------------------------------------------------------------------------
--REACTIVE/IMMEDIATE Game State CNEs
--These are cnes which are used to check the current game state and perform some kind of
--emergency action. They should generally be placed in the overwatch element list at an
--appropriate level in the subtask tree so that they can monitor all subtasks below them
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--NOTARGET: If (no current target) Then (find the nearest fate mob)
--Gets a new target using the targeting function of the parent task
---------------------------------------------------------------------------------------------
c_notarget = inheritsFrom( ml_cause )
e_notarget = inheritsFrom( ml_effect )
function c_notarget:evaluate()
    
    if ( ml_task_hub:CurrentTask().targetFunction() ~= nil ) then
        if ( ml_task_hub:CurrentTask().targetid == nil or ml_task_hub:CurrentTask().targetid == 0 ) then
            return true
        end
        
        local target = EntityList:Get(ml_task_hub:CurrentTask().targetid)
        if (target ~= nil) then
            if (not target.alive or not target.targetable) then
                return true
            end
        elseif (target == nil) then
            return true
        end
    end    
    return false
end
function e_notarget:execute()
    ml_debug( "Getting new target" )
    local target = ml_task_hub:CurrentTask().targetFunction()
    if (target ~= nil and target ~= 0) then
        Player:SetFacing(target.pos.x, target.pos.y, target.pos.z)
        ml_task_hub:CurrentTask().targetid = target.id
    end
end

---------------------------------------------------------------------------------------------
--MOBAGGRO: If (detect new aggro) Then (kill mob)
--
---------------------------------------------------------------------------------------------
c_mobaggro = inheritsFrom( ml_cause )
e_mobaggro = inheritsFrom( ml_effect )
function c_mobaggro:evaluate()
    if ( Player.hasaggro ) then
        local target = GetNearestAggro()
        if (target ~= nil and target ~= 0) then
            e_mobaggro.targetid = target.id
            return true
        end
    end
    
    return false
end
function e_mobaggro:execute()
    ml_debug( "Getting new target" )
    local target = GetNearestAggro()
    if (target ~= nil) then
        local newTask = ffxiv_task_killtarget.Create()
        newTask.targetFunction = ml_task_hub:CurrentTask().targetFunction
        newTask.targetid = e_mobaggro.targetid
        ml_task_hub.Add(newTask, QUEUE_REACTIVE, TP_IMMEDIATE)
    end
end

---------------------------------------------------------------------------------------------
--REST: If (not player.hasAggro and player.hp.percent < 50) Then (do nothing)
--Blocks all subtask execution until player hp has increased
---------------------------------------------------------------------------------------------
c_rest = inheritsFrom( ml_cause )
e_rest = inheritsFrom( ml_effect )
function c_rest:evaluate()
	if (Now() < ml_global_information.suppressRestTimer and ml_global_information.Player_HP.percent > 20) then
		return false
	end
	
	local isDOL = (Player.job >= 16 and Player.job <= 18)
	local isDOH = (Player.job >= 8 and Player.job <= 15)
	
	if (( tonumber(gRestHP) > 0 and ml_global_information.Player_HP.percent < tonumber(gRestHP)) or
		(( tonumber(gRestMP) > 0 and ml_global_information.Player_MP.percent < tonumber(gRestMP)) and not isDOL and not isDOH))
	then
		if (ml_global_information.Player_InCombat or not Player.alive) then
			--d("Cannot rest, still in combat or not alive.")
			return false
		end
		
		local aggrolist = EntityList("alive,aggro")
		if (ValidTable(aggrolist)) then
			return false
		end
		
		-- don't rest if we have rest in fates disabled and we're in a fate or FatesOnly is enabled
		if (gRestInFates == "0") then
			if (gBotMode == GetString("grindMode")) then
				return not IsInsideFate()
			end
		end
	
		return true
	end
    
    return false
end
function e_rest:execute()
	Player:Stop()
	local newTask = ffxiv_task_rest.Create()
	ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
	d("Entering a resting state due to low hp/mp.")
end

---------------------------------------------------------------------------------------------
--FLEE: If (aggolist.size > 0 and health.percent < 50) Then (run to a random point)
--Attempts to shake aggro by running away and resting
---------------------------------------------------------------------------------------------
c_flee = inheritsFrom( ml_cause )
e_flee = inheritsFrom( ml_effect )
e_flee.fleePos = {}
function c_flee:evaluate()
	local params = ml_task_hub:ThisTask().params
	if (params and params.noflee and params.noflee == true) then
		return false
	end
	
	e_flee.fleePos = {}
	
	if ((ml_global_information.Player_InCombat) and (ml_global_information.Player_HP.percent < GetFleeHP() or ml_global_information.Player_MP.percent < tonumber(gFleeMP))) then
		local ppos = ml_global_information.Player_Position
		
		if (ValidTable(ml_marker_mgr.markerList["evacPoint"])) then
			local fpos = ml_marker_mgr.markerList["evacPoint"]
			if (Distance3D(ppos.x, ppos.y, ppos.z, fpos.x, fpos.y, fpos.z) > 50) then
				e_flee.fleePos = fpos
				return true
			end
		end
		
		local newPos = NavigationManager:GetRandomPointOnCircle(ppos.x,ppos.y,ppos.z,100,200)
		if (ValidTable(newPos)) then
			local p,dist = NavigationManager:GetClosestPointOnMesh(newPos)
			if (p) then
				e_flee.fleePos = p
				return true
			end
		end
	end
    
    return false
end
function e_flee:execute()
	local fleePos = e_flee.fleePos
	if (ValidTable(fleePos)) then
		local newTask = ffxiv_task_flee.Create()
		newTask.pos = fleePos
		newTask.useTeleport = (gTeleport == "1")
		ml_task_hub:Add(newTask, IMMEDIATE_GOAL, TP_IMMEDIATE)
	end
end

---------------------------------------------------------------------------------------------
--DEAD: Checks Revivestate of player and revives at nearest aetheryte, homepoint, favpoint or we shall see 
--Blocks all subtask execution until player is alive 
---------------------------------------------------------------------------------------------
c_dead = inheritsFrom( ml_cause )
e_dead = inheritsFrom( ml_effect )
c_dead.timer = 0
e_dead.blockOnly = false
function c_dead:evaluate()	
    if (not Player.alive) then
		if (ml_task_hub:ThisTask().subtask ~= nil) then
			ml_task_hub:ThisTask().subtask = nil
		end
		
		if (gBotMode == GetString("grindMode") or gBotMode == GetString("partyMode")) then
			if (c_dead.timer == 0) then
				c_dead.timer = Now() + 30000
				return false
			end
			if (Now() > c_dead.timer or HasBuffs(Player, "148")) then
				ffxiv_task_grind.inFate = false
				return true
			end
		else
			return true
		end
		
		e_dead.blockOnly = true
		return true
    end 
    return false
end
function e_dead:execute()
	if (ml_task_hub:ThisTask().name == "LT_GRIND") then
		ml_task_hub:ThisTask().targetid = 0
		ml_task_hub:ThisTask().markerTime = 0
		ml_task_hub:ThisTask().currentMarker = false
		ml_global_information.currentMarker = false
		ffxiv_task_grind.inFate = false
	elseif (ml_task_hub:ThisTask().name == "LT_GATHER") then
		ml_task_hub:ThisTask().gatherid = 0
		ml_task_hub:ThisTask().markerTime = 0
		ml_task_hub:ThisTask().currentMarker = false
		ml_global_information.currentMarker = false
		ml_task_hub:ThisTask().gatheredMap = false
		ml_task_hub:ThisTask().gatheredGardening = false
		ml_task_hub:ThisTask().gatheredChocoFood = false
		ml_task_hub:ThisTask().gatheredIxaliRare = false
		ml_task_hub:ThisTask().gatheredSpecialRare = false
		ml_task_hub:ThisTask().idleTimer = 0
		ml_task_hub:ThisTask().swingCount = 0
		ml_task_hub:ThisTask().itemsUncovered = false
		ml_task_hub:ThisTask().slotsTried = {}
		ml_task_hub:ThisTask().rareCount = -1
		ml_task_hub:ThisTask().rareCount2 = -1
		ml_task_hub:ThisTask().rareCount3 = -1
		ml_task_hub:ThisTask().rareCount4 = -1
		ml_task_hub:ThisTask().mapCount = -1
		ml_task_hub:ThisTask().failedSearches = 0 
	elseif (ml_task_hub:ThisTask().name == "LT_FISH") then
		ml_task_hub:ThisTask().castTimer = 0
		ml_task_hub:ThisTask().markerTime = 0
		ml_task_hub:ThisTask().currentMarker = false
		ml_global_information.currentMarker = false
		ml_task_hub:ThisTask().networkLatency = 0
		ml_task_hub:ThisTask().requiresAdjustment = false
		ml_task_hub:ThisTask().snapshot = GetSnapshot()
	end
	
	if (e_dead.blockOnly) then
		e_dead.blockOnly = false
		return
	end
		
	if (ControlVisible("_NotificationParty")) then
		return
	end

	if (Player.revivestate == 2) then
		-- try raise first
		if (PressYesNo(true)) then
			c_dead.timer = 0
			return
		end
		-- press ok
		if (PressOK()) then
			c_dead.timer = 0
			return
		end
	end
end

c_pressconfirm = inheritsFrom( ml_cause )
e_pressconfirm = inheritsFrom( ml_effect )
function c_pressconfirm:evaluate()
	if (gBotMode == GetString("assistMode")) then
		return (gConfirmDuty == "1" and ControlVisible("ContentsFinderConfirm") and not ml_global_information.Player_IsLoading)
	end
	
    return (ControlVisible("ContentsFinderConfirm") and not ml_global_information.Player_IsLoading and Player.revivestate ~= 2 and Player.revivestate ~= 3)
end
function e_pressconfirm:execute()
	PressDutyConfirm(true)
	if (gBotMode == GetString("pvpMode")) then
		ml_task_hub:ThisTask().state = "DUTY_STARTED"
	elseif (gBotMode == GetString("dutyMode") and IsDutyLeader()) then
		ffxiv_task_duty.state = "DUTY_ENTER"
	end
end

-- more to refactor here later most likely
c_returntomarker = inheritsFrom( ml_cause )
e_returntomarker = inheritsFrom( ml_effect )
function c_returntomarker:evaluate()
    if (gBotMode == GetString("partyMode") and not IsLeader()) then
        return false
    end
	
	if (ValidTable(ffxiv_task_fish.currentTask)) then
		return false
	end
	
	local list = Player:GetGatherableSlotList()
	if (list ~= nil) then
		return false
	end
    
	-- right now when randomize markers is active, it first walks to the marker and then checks for levelrange, this should probably get changed, but 
	-- making this will most likely break the behavior on some badly made meshes 
    if (ml_task_hub:CurrentTask().currentMarker ~= false and ml_task_hub:CurrentTask().currentMarker ~= nil) then
	
		local markerType = ml_task_hub:ThisTask().currentMarker:GetType()
		if (markerType == GetString("unspoiledMarker") and not ffxiv_task_gather.IsIdleLocation()) then
			return false
		end
	
        local myPos = ml_global_information.Player_Position
        local pos = ml_task_hub:CurrentTask().currentMarker:GetPosition()
        local distance = Distance2D(myPos.x, myPos.z, pos.x, pos.z)
		
		if (ml_task_hub:CurrentTask().name == "LT_GRIND" or ml_task_hub:CurrentTask().name == "LT_PARTY") then
			local target = ml_task_hub:CurrentTask().targetFunction()
			if (distance > 200 or (target == nil and distance > 10)) then
				return true
			end
		end
		
		if (gBotMode == GetString("pvpMode")) then
			if (ml_task_hub:CurrentTask().state ~= "COMBAT_STARTED" or (ml_global_information.Player_Map ~= 376 and ml_global_information.Player_Map ~= 422)) then
				if (distance > 25) then
					return true
				end
			else
				return false
			end
		end	
		
		if (gBotMode == GetString("huntMode")) then
			if (distance > 15) then
				return true
			end
		end		
		
		if (gBotMode == GetString("gatherMode")) then
			local gatherid = ml_task_hub:CurrentTask().gatherid or 0
			if (gatherid == 0 and distance > 25) then
				d("No gatherable currently, return to the marker.")
				return true
			end
			if (gMarkerMgrMode ~= GetString("markerTeam")) then
				local radius = 150
				local maxradius = ml_global_information.currentMarker:GetFieldValue(GetUSString("maxRadius"))
				if (tonumber(maxradius) and tonumber(maxradius) > 0) then
					radius = tonumber(maxradius)
				end
				if (distance > radius) then
					return true
				end
			end
		end
		
        if (gBotMode == GetString("fishMode") and distance > 3) then
            return true
        end
    end
    
    return false
end
function e_returntomarker:execute()
	if (gBotMode == GetString("fishMode")) then
		local fs = tonumber(Player:GetFishingState())
		if (fs ~= 0) then
			local finishcast = ActionList:Get(299,1)
			if (finishcast and finishcast.isready) then
				finishcast:Cast()
			end
			return
		end
	end
	
    local newTask = ffxiv_task_movetopos.Create()
    local markerPos = ml_global_information.currentMarker:GetPosition()
    local markerType = ml_global_information.currentMarker:GetType()
    newTask.pos = markerPos
    newTask.range = math.random(3,5)
	if (markerType == GetString("huntMarker") or
		markerType == GetString("miningMarker") or
		markerType == GetString("botanyMarker")) 
	then
		newTask.remainMounted = true
	end
    if (markerType == GetString("fishingMarker")) then
        newTask.pos.h = markerPos.h
        newTask.range = 0.5
        newTask.doFacing = true
    end
	if (gTeleport == "1") then
		newTask.useTeleport = true
	end
	
	if (markerType == GetString("miningMarker") or
		markerType == GetString("botanyMarker"))
	then
		newTask.stealthFunction = ffxiv_task_gather.NeedsStealth
	elseif (markerType == GetString("fishingMarker")) then
		newTask.stealthFunction = ffxiv_task_fish.NeedsStealth
	end
	
	--[[
	newTask.abortFunction = function()
		if (gBotMode == GetString("grindMode")) then
			local newTarget = GetNearestGrind()
			if (ValidTable(newTarget)) then
				return true
			end
			
			if (gGather == "1") then
				local node = eso_gather_manager.ClosestNode(true)
				if (ValidTable(node)) then
					return true
				end
			end
		end
		if (gBotMode == GetString("gatherMode")) then
			local node = eso_gather_manager.ClosestNode(true)
			if (ValidTable(node)) then
				return true
			end
		end
		return false
	end
	--]]
	
    ml_task_hub:CurrentTask():AddSubTask(newTask)
end

--------------------------------------------------------------------------------------------
--  Keep track of whether we need stealth or not so other cne's know if they can break it.
--------------------------------------------------------------------------------------------
c_stealthupdate = inheritsFrom( ml_cause )
e_stealthupdate = inheritsFrom( ml_effect )
c_stealthupdate.timer = 0
function c_stealthupdate:evaluate()	
	local stealthFunction = ml_task_hub:CurrentTask().stealthFunction
	if (stealthFunction ~= nil and type(stealthFunction) == "function") then
		
		local list = Player:GetGatherableSlotList()
		local fs = tonumber(Player:GetFishingState())
		if (ValidTable(list) or fs ~= 0) then
			return false
		end
		
		local needsStealth = stealthFunction()
		if (ml_global_information.needsStealth ~= needsStealth) then
			ml_global_information.needsStealth = needsStealth
		end
	else
		if (ml_global_information.needsStealth ~= false) then
			ml_global_information.needsStealth = false
		end	
	end
	
	return false
end
function e_stealthupdate:execute()
	--Nothing here, just update the variable.
end

--[[
c_stealthmove = inheritsFrom( ml_cause )
e_stealthmove = inheritsFrom( ml_effect )
e_stealthmove.addDrop = ""
function c_stealthmove:evaluate()
	--Tempvar reset.
	e_stealthmove.addDrop = ""
	
	local stealthFunction = ml_task_hub:CurrentTask().stealthFunction
	if (stealthFunction ~= nil and type(stealthFunction) == "function") then
		
		local list = Player:GetGatherableSlotList()
		local fs = tonumber(Player:GetFishingState())
		if (ValidTable(list) or fs ~= 0) then
			return false
		end
		
		local needsStealth = stealthFunction()
		local hasStealth = HasBuff(Player.id,47)
		if (not hasStealth and needsStealth) then
			e_stealthmove.addDrop = "add"
			return true
		elseif (hasStealth and not needsStealth) then
			e_stealthmove.addDrop = "drop"
			return true
		end
	end
 
    return false
end
function e_stealthmove:execute()
	local newTask = ffxiv_task_stealth.Create()
	if (e_stealthmove.addDrop == "drop") then
		newTask.droppingStealth = true
		ml_global_information.needsStealth = false
	else
		newTask.addingStealth = true
		ml_global_information.needsStealth = true
	end
	ml_task_hub:Add(newTask, REACTIVE_GOAL, TP_IMMEDIATE)
end
--]]

c_acceptquest = inheritsFrom( ml_cause )
e_acceptquest = inheritsFrom( ml_effect )
function c_acceptquest:evaluate()
	if (gBotMode == GetString("assistMode") and gQuestHelpers == "0") then
		return false
	end
	return Quest:IsQuestAcceptDialogOpen()
end
function e_acceptquest:execute()
	Quest:AcceptQuest()
end

c_handoverquest = inheritsFrom( ml_cause )
e_handoverquest = inheritsFrom( ml_effect )
function c_handoverquest:evaluate()
	if (gBotMode == GetString("assistMode") and gQuestHelpers == "0") then
		return false
	end
	return Quest:IsRequestDialogOpen()
end
function e_handoverquest:execute()
	local inv = Inventory("type=2004")

	for id, item in pairs(inv) do 
		if (item:HandOver()) then
			d("Handed over item ID:"..tostring(item.id))
			ml_task_hub:CurrentTask():SetDelay(1000)
			return
		end
	end			
	Quest:RequestHandOver()
end

c_completequest = inheritsFrom( ml_cause )
e_completequest = inheritsFrom( ml_effect )
function c_completequest:evaluate()
	if (gBotMode == GetString("assistMode") and gQuestHelpers == "0") then
		return false
	end
	return Quest:IsQuestRewardDialogOpen()
end
function e_completequest:execute()
	Quest:CompleteQuestReward(0)
end

c_teleporttopos = inheritsFrom( ml_cause )
e_teleporttopos = inheritsFrom( ml_effect )
c_teleporttopos.pos = 0
e_teleporttopos.teleCooldown = 0
function c_teleporttopos:evaluate()
	if (Now() < e_teleporttopos.teleCooldown or gTeleport == "0" or IsFlying()) then
		return false
	end
	
	local useTeleport = ml_task_hub:CurrentTask().useTeleport
	if (ml_global_information.Player_IsCasting or ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or IsMounting() or 
		ControlVisible("SelectString") or ControlVisible("SelectIconString") or IsShopWindowOpen() or
		not ValidTable(ml_task_hub:CurrentTask().pos) or not useTeleport) 
	then
		return false
	end
	
	local myPos = ml_global_information.Player_Position
	local gotoPos = ml_task_hub:CurrentTask().pos
	
	if (not ValidTable(gotoPos) or c_rest:evaluate() or not ShouldTeleport(gotoPos)) then
		return false
	end
	 
	local distance = PDistance3D(myPos.x, myPos.y, myPos.z, gotoPos.x, gotoPos.y, gotoPos.z)
	if (distance > 10) then
		local properPos = nil
		if (ml_task_hub:CurrentTask().gatePos) then
			properPos = ml_task_hub:CurrentTask().pos
		else
			properPos = ml_task_hub:CurrentTask().pos
			local p,dist = NavigationManager:GetClosestPointOnMesh(properPos)
			if (p and dist > 10) then
				properPos = p
			end
		end
		
		c_teleporttopos.pos = properPos
		return true
	end
    return false
end
function e_teleporttopos:execute()
    if ( c_teleporttopos.pos ~= 0) then
        local gotoPos = c_teleporttopos.pos
		Player:Stop()
		
        GameHacks:TeleportToXYZ(tonumber(gotoPos.x),tonumber(gotoPos.y),tonumber(gotoPos.z))
		ml_global_information.queueSync = {timer = Now() + 150, pos = gotoPos}
		e_teleporttopos.teleCooldown = Now() + 1000
    else
        ml_error(" Critical error in e_walktopos, c_walktopos.pos == 0!!")
    end
    c_teleporttopos.pos = 0
end

c_autoequip = inheritsFrom( ml_cause )
e_autoequip = inheritsFrom( ml_effect )
e_autoequip.item = nil
e_autoequip.bag = nil
e_autoequip.slot = nil
--e_autoequip.id = nil
--e_autoequip.slot = nil
function c_autoequip:evaluate()	
	if (gQuestAutoEquip == "0" or 
		IsShopWindowOpen() or ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or 
		not Player.alive or ml_global_information.Player_InCombat or
		Player:GetGatherableSlotList() or Player:GetFishingState() ~= 0) 
	then
		return false
	end
	
	e_autoequip.item = nil
	e_autoequip.bag = nil
	e_autoequip.slot = nil
	
	if (ValidTable(ffxiv_task_quest.lockedSlots)) then
		for slot,questid in pairs(ffxiv_task_quest.lockedSlots) do
			if (Quest:IsQuestCompleted(questid)) then
				ffxiv_task_quest.lockedSlots[slot] = nil
			end
		end
	end
	
	local applicableSlots = {
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[10] = true,
		[11] = true,
		[12] = true,
	}
	
	for slot,data in pairs(applicableSlots) do
		if (ffxiv_task_quest.lockedSlots[slot] or IsArmoryFull(slot)) then
			applicableSlots[slot] = nil
		else
			applicableSlots[slot] = {}
			applicableSlots[slot].equippedItem = 0
			applicableSlots[slot].equippedValue = 0
			applicableSlots[slot].unequippedItem = 0
			applicableSlots[slot].unequippedValue = 0
		end
	end
	
	-- Fill with comparison data.
	for slot,data in pairs(applicableSlots) do
		local equipped = Inventory("type=1000")
		if (ValidTable(equipped)) then
			for _,item in pairs(equipped) do
				local found = false
				if (item.slot == slot and item.id ~= 0) then
					found = true
					data.equippedValue = AceLib.API.Items.GetItemStatWeight(item,slot)
					data.equippedItem = item
					
					--d("Slot ["..tostring(slot).."] Equipped item has a value of :"..tostring(data.equippedValue))
				end
				if (found) then
					break
				end
			end
		end
		
		if (slot == 0) then
			data.unequippedItem,data.unequippedValue = AceLib.API.Items.FindWeaponUpgrade()
			--d("Slot ["..tostring(slot).."] Best upgrade item has a value of :"..tostring(data.unequippedValue))
		elseif (slot == 1) then
			if (AceLib.API.Items.IsShieldEligible()) then
				data.unequippedItem,data.unequippedValue = AceLib.API.Items.FindShieldUpgrade()
				--d("Slot ["..tostring(slot).."] Best upgrade item has a value of :"..tostring(data.unequippedValue))
			end
		else
			data.unequippedItem,data.unequippedValue = AceLib.API.Items.FindArmorUpgrade(slot)
			--d("Slot ["..tostring(slot).."] Best upgrade item has a value of :"..tostring(data.unequippedValue))
		end
	end
	
	for slot,data in pairs(applicableSlots) do		
		if (data.unequippedItem ~= 0 and data.unequippedValue > data.equippedValue) then
			if (ArmoryItemCount(slot) == 25) then
				local firstBag,firstSlot = GetFirstFreeInventorySlot()
				if (firstBag ~= nil) then
					if (slot == 0) then
						local downgrades = AceLib.API.Items.FindWeaponDowngrades()
						if (ValidTable(downgrades)) then
							for i,item in pairs(downgrades) do
								if (item.bag > 3) then
									d("Armoury slots for ["..tostring(slot).."] are full, attempting to rearrange inventory.")
									d("Will attempt to place item ["..tostring(item.id).."] into bag ["..tostring(firstBag).."], slot ["..tostring(firstSlot).."].")
									
									e_autoequip.item = item
									e_autoequip.bag = firstBag
									e_autoequip.slot = firstSlot
									return true
								end
							end
						end
					elseif (slot == 1) then
						local downgrades = AceLib.API.Items.FindShieldDowngrades()
						if (ValidTable(downgrades)) then
							for i,item in pairs(downgrades) do
								if (item.bag > 3) then
									d("Armoury slots for ["..tostring(slot).."] are full, attempting to rearrange inventory.")
									
									e_autoequip.item = item
									e_autoequip.bag = firstBag
									e_autoequip.slot = firstSlot
									return true
								end
							end
						end
					else
						local downgrades = AceLib.API.Items.FindArmorDowngrades(slot)
						if (ValidTable(downgrades)) then
							for i,item in pairs(downgrades) do
								if (item.bag > 3) then
									d("Armoury slots for ["..tostring(slot).."] are full, attempting to rearrange inventory.")
									
									e_autoequip.item = item
									e_autoequip.bag = firstBag
									e_autoequip.slot = firstSlot
									return true
								end
							end
						end
					end
				end
				
				d("Autoequip cannot be used for slot ["..tostring(slot).."], all armoury slots are full.")
				return false
			end
			
			e_autoequip.item = data.unequippedItem
			e_autoequip.bag = 1000
			e_autoequip.slot = slot
			return true
		end
	end
	
	return false
end
function e_autoequip:execute()
	local item = e_autoequip.item
	if (ValidTable(item)) then
		--d("Moving item ["..tostring(item.id).."] to bag "..tostring(e_autoequip.bag)..", slot "..tostring(e_autoequip.slot))
		item:Move(e_autoequip.bag,e_autoequip.slot)
	end
	if (ml_task_hub:CurrentTask()) then
		ml_task_hub:CurrentTask():SetDelay(200)
	end
	
	--[[
	local item = GetUnequippedItem(e_autoequip.id)
	if(ValidTable(item) and item.type ~= FFXIV.INVENTORYTYPE.INV_EQUIPPED) then
		item:Move(1000,e_autoequip.slot)
		if (ml_task_hub:CurrentTask()) then
			ml_task_hub:CurrentTask():SetDelay(500)
		end
	end
	--]]
end

c_selectconvindex = inheritsFrom( ml_cause )
e_selectconvindex = inheritsFrom( ml_effect )
c_selectconvindex.unexpected = 0
function c_selectconvindex:evaluate()	
	if (c_selectconvindex.unexpected > 5) then
		c_selectconvindex.unexpected = 0
	end
	return (ControlVisible("SelectIconString") or ControlVisible("SelectString"))
end
function e_selectconvindex:execute()	
	local index = ml_task_hub:CurrentTask().conversationIndex
	if (not index) then
		c_selectconvindex.unexpected = c_selectconvindex.unexpected + 1
		index = c_selectconvindex.unexpected
	end
	SelectConversationIndex(tonumber(index))
	ml_task_hub:ThisTask():SetDelay(1000)
end

c_returntomap = inheritsFrom( ml_cause )
e_returntomap = inheritsFrom( ml_effect )
e_returntomap.mapID = 0
function c_returntomap:evaluate()
	if (ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or not Player.alive) then
		return false
	end
	
	if (ml_task_hub:ThisTask().correctMap and (ml_task_hub:ThisTask().correctMap ~= ml_global_information.Player_Map)) then
		local mapID = ml_task_hub:ThisTask().correctMap
		if (mapID and mapID > 0) then
			local pos = ml_nav_manager.GetNextPathPos(	ml_global_information.Player_Position,
														ml_global_information.Player_Map,
														mapID	)
			if(ValidTable(pos)) then
				e_returntomap.mapID = mapID
				return true
			end
		end
	end
	
	return false
end
function e_returntomap:execute()
	local task = ffxiv_task_movetomap.Create()
	task.setHomepoint = true
	task.destMapID = e_returntomap.mapID
	ml_task_hub:Add(task, IMMEDIATE_GOAL, TP_IMMEDIATE)
end

c_inventoryfull = inheritsFrom( ml_cause )
e_inventoryfull = inheritsFrom( ml_effect )
function c_inventoryfull:evaluate()
	if (IsInventoryFull()) then
		return true
	end
	
    return false
end
function e_inventoryfull:execute()
	if (gBotRunning == "1") then
		GUI_ToggleConsole(true)
		d("Inventory is full, bot will stop.")
		ml_task_hub:ToggleRun()
	end
end

c_unpackdata = inheritsFrom( ml_cause )
e_unpackdata = inheritsFrom( ml_effect )
function c_unpackdata:evaluate()
	--if (not ml_task_hub:CurrentTask().dataUnpacked and (ml_task_hub:CurrentTask().encounterData or ml_task_hub:CurrentTask().params)) then
		--return true
	--end
	
    return false
end
function e_unpackdata:execute()
	if (ml_task_hub:CurrentTask().encounterData) then
		
	end
	ml_task_hub:CurrentTask().dataUnpacked = true
end

c_falling = inheritsFrom( ml_cause )
e_falling = inheritsFrom( ml_effect )
c_falling.jumpKillTimer = 0
c_falling.lastMeasure = 0
function c_falling:evaluate()
	local myPos = ml_global_information.Player_Position
	if (Player:IsJumping()) then
		if (c_falling.jumpKillTimer == 0) then
			c_falling.jumpKillTimer = Now() + 1000
			c_falling.lastY = myPos.y
		elseif (Now() > c_falling.jumpKillTimer) then
			if (myPos.y < (c_falling.lastY - 3)) then
				return true
			end
		end
	else
		if (c_falling.jumpKillTimer ~= 0) then
			c_falling.jumpKillTimer = 0
			c_falling.lastY = 0
		end
	end
	
    return false
end
function e_falling:execute()
	Player:Stop()
	c_falling.jumpKillTimer = 0
end

c_clearaggressive = inheritsFrom( ml_cause )
e_clearaggressive = inheritsFrom( ml_effect )
c_clearaggressive.targetid = 0
c_clearaggressive.timer = 0
function c_clearaggressive:evaluate()
	if (ml_global_information.Player_IsCasting or ml_global_information.Player_IsLocked or ml_global_information.Player_IsLoading or ControlVisible("SelectYesno") or ControlVisible("SelectString") or ControlVisible("SelectIconString")) then
		return false
	end
	
	if (Now() < c_clearaggressive.timer) then
		return false
	end
	
	--Reset the tempvar.
	c_clearaggressive.targetid = 0
	
	local clearAggressive = ml_task_hub:CurrentTask().clearAggressive or false
	if (clearAggressive) then
		local ppos = ml_global_information.Player_Position
		local id = ml_task_hub:CurrentTask().targetid or 0
		if (id > 0) then
			local el = EntityList("shortestpath,targetable,contentid="..tostring(id))
			if (el) then
				local i,entity = next(el)
				if (i and entity) then
					local epos = entity.pos
					c_clearaggressive.timer = Now() + 5000
					local aggroChecks = GetAggroDetectionPoints(ppos,epos)
					if (ValidTable(aggroChecks)) then
						for k,navPos in pairsByKeys(aggroChecks) do
							local aggressives = EntityList("aggressive,alive,attackable,targeting=0,minlevel="..tostring(Player.level - 10)..",exclude_contentid="..tostring(id))
							if (ValidTable(aggressives)) then
								for _,aggressive in pairs(aggressives) do
									local agpos = aggressive.pos
									local dist = PDistance3D(navPos.x,navPos.y,navPos.z,agpos.x,agpos.y,agpos.z)
									local tdist = PDistance3D(navPos.x,navPos.y,navPos.z,epos.x,epos.y,epos.z)
									if (dist <= 12 and dist < tdist) then
										c_questclearaggressive.targetid = aggressive.id
										return true
									end
								end
							end
						end
					end
				end
			end
		elseif (ml_task_hub:CurrentTask().pos) then
			local dest = ml_task_hub:CurrentTask().pos
			c_clearaggressive.timer = Now() + 5000
			local aggroChecks = GetAggroDetectionPoints(ppos,dest)
			if (ValidTable(aggroChecks)) then
				for k,navPos in pairsByKeys(aggroChecks) do
					local aggressives = nil
					if (gBotMode == "NavTest") then
						local aggressives = EntityList("aggressive,alive,attackable,targeting=0")
					else
						local aggressives = EntityList("aggressive,alive,attackable,targeting=0,minlevel="..tostring(Player.level - 10))
					end
					if (ValidTable(aggressives)) then
						for _,aggressive in pairs(aggressives) do
							local agpos = aggressive.pos
							local dist = PDistance3D(navPos.x,navPos.y,navPos.z,agpos.x,agpos.y,agpos.z)
							if (dist <= 15) then
								c_questclearaggressive.targetid = aggressive.id
								return true
							end
						end
					end
				end
			end
		end
	end
    
    return false
end
function e_clearaggressive:execute()	
	--just in case
	Player:Stop()
	Dismount()
	
	local newTask = ffxiv_task_grindCombat.Create()
    newTask.targetid = c_questclearaggressive.targetid
	Player:SetTarget(c_questclearaggressive.targetid)
	ml_task_hub:CurrentTask():AddSubTask(newTask)
end

c_isloading = inheritsFrom( ml_cause )
e_isloading = inheritsFrom( ml_effect )
function c_isloading:evaluate()
	return ml_global_information.Player_IsLoading
end
function e_isloading:execute()
	d("Character is loading, prevent other actions and idle.")
end

c_mapyesno = inheritsFrom( ml_cause )
e_mapyesno = inheritsFrom( ml_effect )
function c_mapyesno:evaluate()
	return ControlVisible("SelectYesno")
end
function e_mapyesno:execute()
	if (ControlVisible("_NotificationParty")) then
		PressYesNo(false)
	else
		PressYesNo(true)
	end
	ml_task_hub:ThisTask().preserveSubtasks = true
end

c_reachedmap = inheritsFrom( ml_cause )
e_reachedmap = inheritsFrom( ml_effect )
function c_reachedmap:evaluate()
	return (Player.localmapid == ml_task_hub:ThisTask().destMapID)
end
function e_reachedmap:execute()
	ml_task_hub:ThisTask().completed = true
end

c_movetomap = inheritsFrom( ml_cause )
e_movetomap = inheritsFrom( ml_effect )
function c_movetomap:evaluate()
	if (ml_global_information.Player_IsCasting or (ml_global_information.Player_IsLocked and not IsFlying()) or ml_global_information.Player_IsLoading) then
		return false
	end
	
	local mapID = ml_task_hub:CurrentTask().mapid
	if (mapID and mapID > 0) then
		if (Player.localmapid ~= mapID) then
			if (CanAccessMap(mapID)) then
				e_movetomap.mapID = mapID
				return true
			end
		end
	end
	
	return false
end
function e_movetomap:execute()
	local task = ffxiv_task_movetomap.Create()
	task.destMapID = e_movetomap.mapID
	if (ValidTable(ml_task_hub:CurrentTask().pos)) then
		task.pos = ml_task_hub:CurrentTask().pos
	end
	ml_task_hub:CurrentTask():AddSubTask(task)
end

c_buy = inheritsFrom( ml_cause )
e_buy = inheritsFrom( ml_effect )
function c_buy:evaluate()	
	if (not IsShopWindowOpen()) then
		return false
	end
	
	local itemid;
	local itemtable = ml_task_hub:CurrentTask().itemid
	if (ValidTable(itemtable)) then
		itemid = itemtable[Player.job] or itemtable[-1]
	elseif (tonumber(itemtable)) then
		itemid = tonumber(itemtable)
	end
	
	if (itemid) then
		e_buy.itemid = tonumber(itemid)
		return true
	end
	
	return false
end
function e_buy:execute()
	local buyamount = ml_task_hub:CurrentTask().buyamount or 1
	Inventory:BuyShopItem(e_buy.itemid,buyamount)
	ml_task_hub:CurrentTask():SetDelay(1000)
end

c_moveandinteract = inheritsFrom( ml_cause )
e_moveandinteract = inheritsFrom( ml_effect )
c_moveandinteract.entityid = 0
function c_moveandinteract:evaluate()
	if (ml_global_information.Player_IsCasting or (ml_global_information.Player_IsLocked and not IsFlying()) or ml_global_information.Player_IsLoading or 
		ControlVisible("SelectString") or ControlVisible("SelectIconString")) 
	then
		return false
	end
	
	local id = ml_task_hub:CurrentTask().id
    if (id and id > 0) then
		return true
    end
	
	return false
end
function e_moveandinteract:execute()
	local newTask = ffxiv_task_movetointeract.Create()
	newTask.uniqueid = ml_task_hub:CurrentTask().id
	newTask.pos = ml_task_hub:CurrentTask().pos
	newTask.use3d = true
	
	--local range = params["range"]
	--if (range and range < 1) then
		--range = 1
	--end
	--newTask.interactRange = range
	
	if (gTeleport == "1") then
		newTask.useTeleport = true
	end
	
	ml_task_hub:ThisTask():AddSubTask(newTask)
end
