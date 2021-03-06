if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Loa Council", 2070, 2330)
if not mod then return end
mod:RegisterEnableMob(0)
mod.engageId = 2268
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		282736, -- Loa's Wrath
		282079, -- Loa's Pact
		286060, -- Cry of the Fallen
		-- Pa'ku's Aspect
		282098, -- Gift of Wind
		285945, -- Hastening Winds
		282107, -- Pa'ku's Wrath
		-- Gonk's Aspect
		{282135, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Crawling Hex
		285893, -- Wild Maul
		282155, -- Gonk's Wrath
		{282209, "FLASH"}, -- Mark of Prey
		-- Kimbul's Aspect
		{282444, "TANK"}, -- Lacerating Claws
		282447, -- Kimbul's Wrath
		-- Akunda's Aspect
		282411, -- Thundering Storm
		285878, -- Mind Wipe
		{286811, "SAY", "SAY_COUNTDOWN"}, -- Akunda's Wrath
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LoasWrath", 282736)
	self:Log("SPELL_AURA_APPLIED", "LoasPact", 282079)
	self:Log("SPELL_CAST_SUCCESS", "CryoftheFallen", 286060)

	-- Pa'ku's Aspect
	self:Log("SPELL_CAST_START", "GiftofWind", 282098)
	self:Log("SPELL_AURA_APPLIED", "HasteningWinds", 285945)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HasteningWinds", 285945)
	self:Log("SPELL_CAST_START", "PakusWrath", 282107)

	-- Gonk's Aspect
	self:Log("SPELL_AURA_APPLIED", "CrawlingHexApplied", 282135)
	self:Log("SPELL_AURA_REMOVED", "CrawlingHexRemoved", 282135)
	self:Log("SPELL_CAST_SUCCESS", "WildMaul", 285893)
	self:Log("SPELL_CAST_START", "GonksWrath", 282155)
	self:Log("SPELL_AURA_APPLIED", "MarkofPrey", 282135)

	-- Kimbul's Aspect
	self:Log("SPELL_AURA_APPLIED", "LaceratingClawsApplied", 285945)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LaceratingClawsApplied", 285945)
	self:Log("SPELL_CAST_SUCCESS", "KimbulsWrath", 282447)

	-- Akunda's Aspect
	self:Log("SPELL_CAST_START", "ThunderingStorm", 282411)
	self:Log("SPELL_CAST_START", "MindWipe", 285878)
	self:Log("SPELL_AURA_APPLIED", "AkundasWrathApplied", 286811)
	self:Log("SPELL_AURA_APPLIED", "AkundasWrathRemoved", 286811)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LoasWrath(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:LoasPact(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:CryoftheFallen(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 6)
end

function mod:GiftofWind(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:HasteningWinds(args)
	local amount = args.amount or 1
	if amount % 2 == 1 and amount > 4 then
		self:StackMessage(args.spellId, args.destName, args.amount, "purple")
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

function mod:PakusWrath(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CrawlingHexApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:CrawlingHexRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:WildMaul(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:GonksWrath(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:MarkofPrey(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:LaceratingClawsApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:KimbulsWrath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ThunderingStorm(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:MindWipe(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:AkundasWrathApplied(args)
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "orange", playerList)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:AkundasWrathRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end
