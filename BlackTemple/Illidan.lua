﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil
local bCount = 0
local p2Announced = nil
local p4Announced = nil
local flamesDead = 0
local flamed = { }

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Illidan",

	parasite = "Parasitic Shadowfiend",
	parasite_desc = "Warn who has Parasitic Shadowfiend.",
	parasite_you = "You have a Parasite!",
	parasite_other = "%s has a Parasite!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Parasitic Shadowfiend.",

	barrage = "Dark Barrage",
	barrage_desc = "Warn who has Dark Barrage.",
	barrage_message = "%s is being Barraged!",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",

	shear = "Shear",
	shear_desc = "Warn about Shear on players.",
	shear_message = "Shear on %s!",
	shear_bar = "Shear: %s",

	flame = "Agonizing Flames",
	flame_desc = "Warn who has Agonizing Flames.",
	flame_message = "%s has Agonizing Flames!",

	demons = "Shadow Demons",
	demons_desc = "Warn when Illidan is summoning Shadow Demons.",
	demons_trigger = "Summon Shadow Demons",
	demons_message = "Shadow Demons!",

	phase = "Phases",
	phase_desc = "Warns when Illidan goes into different stages.",
	phase2_soon_message = "Phase 2 soon!",
	phase2_trigger = "Blade of Azzinoth casts Summon Tear of Azzinoth.",
	phase2_message = "Phase 2 - Blades of Azzinoth!",
	phase3_message = "Phase 3!",
	demon_phase_trigger = "Behold the power... of the demon within!",
	demon_phase_message = "Demon Form!",
	phase4_trigger = "Is this it, mortals? Is this all the fury you can muster?",
	phase4_soon_message = "Phase 4 soon!",
	phase4_message = "Phase 4 - Maiev Incoming!",

	flameburst = "Flame Burst",
	flameburst_desc = "Warns when Illidan will use Flame Burst",
	flameburst_message = "Flame Burst!",
	flameburst_cooldown_bar = "Flame Burst cooldown",
	flameburst_cooldown_warn = "Flame Burst soon!",
	flameburst_warn = "Flame Burst in ~5sec!",

	enrage_trigger = "Illidan Stormrage gains Enrage.",
	enrage_message = "Enraged!",

	afflict_trigger = "^([^%s]+) ([^%s]+) afflicted by ([^%s]+)%.$",
	["Flame of Azzinoth"] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	parasite = "Ombrefiel parasite",
	parasite_desc = "Préviens quand un joueur subit les effets de l'Ombrefiel parasite.",
	parasite_you = "Vous avez un parasite !",
	parasite_other = "%s a un parasite !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombrefiel parasite (nécessite d'être promu ou mieux).",

	barrage = "Barrage noir",
	barrage_desc = "Préviens quand un joueur subit les effets du Barrage noir.",
	barrage_message = "%s est dans le barrage !",

	eyeblast = "Energie oculaire",
	eyeblast_desc = "Préviens quand l'Energie oculaire est incanté.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!", -- à traduire
	eyeblast_message = "Energie oculaire !",

	flame = "Flammes déchirantes",
	flame_desc = "Préviens quand un joueur subit les effets des Flammes déchirantes.",
	flame_message = "%s a les Flammes déchirantes !",

	demons = "Démons des ombres",
	demons_desc = "Préviens quand Illidan invoque des démons des ombres.",
	demons_trigger = "Invocation de démons des ombres",
	demons_message = "Démons des ombres !",

	afflict_trigger = "^([^%s]+) ([^%s]+) les effets .* ([^%s]+)%.$",
} end )

L:RegisterTranslations("koKR", function() return {
	parasite = "어둠의 흡혈마귀",
	parasite_desc = "어둠의 흡혈마귀에 걸린 플레이어를 알립니다.",
	parasite_you = "당신에 흡혈마귀!",
	parasite_other = "%s에 흡혈마귀!",

	icon = "전술 표시",
	icon_desc = "어둠의 흡혈마귀에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	barrage = "암흑의 보호막",
	barrage_desc = "암흑의 보호막에 걸린 플레이어를 알립니다.",
	barrage_message = "%s에 탄막!",

	eyeblast = "안광",
	eyeblast_desc = "안광 시전 시 알립니다.",
	eyeblast_trigger = "배신자의 눈을 똑바로 쳐다봐라!",
	eyeblast_message = "안광!",

	shear = "베어내기",
	shear_desc = "베어내기에 걸린 플레이어를 알립니다.",
	shear_message = "%s에 베어내기!",
	shear_bar = "베어내기: %s",

	flame = "고뇌의 불꽃",
	flame_desc = "고뇌의 불꽃에 걸린 플레이어를 알립니다.",
	flame_message = "%s에 고뇌의 불꽃!",

	demons = "어둠의 악마",
	demons_desc = "어둠의 악마 소환 시 알립니다.",
	demons_trigger = "어둠의 악마 소환",
	demons_message = "어둠의 악마!",

	phase = "단계",
	phase_desc = "단계 변경에 대해 알립니다.",
	phase2_soon_message = "잠시 후 2 단계!",
	phase2_trigger = "Blade of Azzinoth casts Summon Tear of Azzinoth.",
	phase2_message = "2 단계 - 아지노스의 칼날!",
	phase3_message = "3 단계!",
	demon_phase_trigger = "Behold the power... of the demon within!",
	demon_phase_message = "악마 변신!",
	phase4_trigger = "Is this it, mortals? Is this all the fury you can muster?",
	phase4_soon_message = "잠시 후 4 단계!",
	phase4_message = "4 단계 - 마이에브 등장!",

	flameburst = "화염 폭발",
	flameburst_desc = "일리단의 화염 폭발 사용을 알립니다.",
	flameburst_message = "화염 폭발!",
	flameburst_cooldown_bar = "화염 폭발 대기시간",
	flameburst_cooldown_warn = "잠시 후 화염 폭발!",
	flameburst_warn = "5초 이내 화염 폭발!",

	enrage_trigger = "일리단 스톰레이지이|1이;가; 분노 효과를 얻었습니다.",
	enrage_message = "분노!",

	afflict_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
	["Flame of Azzinoth"] = "아지노스의 불꽃",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", "parasite", "shear", "eyeblast", "barrage", "flame", "demons", "flameburst", "enrage", "bosskill"}
mod.wipemobs = {L["Flame of Azzinoth"]}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliFlame", 0)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	--self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "IliPara" and rest and self.db.profile.parasite then
		local other = L["parasite_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["parasite_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "IliBara" and rest and self.db.profile.barrage then
		self:Message(L["barrage_message"]:format(rest), "Important", nil, "Alert")
		self:Bar(L["barrage_bar"]:format(rest), 10, "Spell_Shadow_PainSpike")

		self:Bar(L["barrage_warn_bar"], 50, "Spell_Shadow_PainSpike")
		self:ScheduleEvent("BarrageWarn", "BigWigs_Message", 47, L["barrage_warn"], "Important")

	elseif sync == "IliFlame" and rest and self.db.profile.flame then
		flamed[rest] = true
		self:ScheduleEvent("FlameCheck", self.FlameWarn, 1, self)
	elseif sync == "IliDemons" and self.db.profile.demons then
		self:Message(L["demons_message"], "Important", nil, "Alert")
	elseif sync == "IliBurst" and self.db.profile.flameburst then
		bCount = bCount + 1
		self:Message(L["flameburst_message"], "Important", nil, "Alert")
		if bCount < 3 then	-- He'll only do three times before transforming again
			self:Bar(L["flameburst"], 20, "Spell_Fire_BlueRainOfFire")
			self:DelayedMessage(15, L["flameburst_warn"], "Positive")
		end
	elseif sync == "IliEnrage" and self.db.profile.enrage then
		self:Message(L["enrage_message"], "Important", nil, "Alert")
	elseif sync == "IliPhase2" then
		flamesDead = 0
		if self.db.profile.barrage then
			self:Bar(L["barrage_warn_bar"], 80, "Spell_Shadow_PainSpike")
			self:DelayedMessage(77, L["barrage_warn"], "Important")
		end
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important", nil, "Alarm")
		end
	elseif sync == "IliFlameDied" then
		flamesDead = flamesDead + 1
		if flamesDead == 2 then
			if self.db.profile.phase then
				self:Message(L["phase3_message"], "Important", nil, "Alarm")
			end
			self:CancelScheduledEvent("BarrageWarn")
		end
	elseif sync == "IliShear" and self.db.profile.shear and rest then
		self:Message(L["shear_message"]:format(rest), "Important", nil, "Alert")
		self:Bar(L["shear_bar"]:format(rest), 7, "Spell_Shadow_FocusedPower")
	end
end

function mod:AfflictEvent(msg)
	local player, type, spell = select(3, msg:find(L["afflict_trigger"]))
	if player and type then
		if player == L2["you"] and type == L2["are"] then
			player = pName
		end
		if spell == L["parasite"] then
			self:Sync("IliPara "..player)
		elseif spell == L["barrage"] then
			self:Sync("IliBara "..player)
		elseif spell == L["flame"] then
			self:Sync("IliFlame "..player)
		elseif spell == L["shear"] then
			self:Sync("IliShear "..player)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["eyeblast_trigger"] and self.db.profile.eyeblast then
		self:Message(L["eyeblast_message"], "Important", nil, "Alert")
	elseif msg == L["demon_phase_trigger"] then
		bCount = 0
		if self.db.profile.demons then
			self:Bar(L["demons"], 30, "Spell_Shadow_SoulLeech_3")
			self:DelayedMessage(25, L["demons_warn"], "Positive")
		end
		if self.db.profile.phase then
			self:Message(L["demon_phase_message"], "Important", nil, "Alarm")
		end
		if self.db.profile.flameburst then
			self:DelayedMessage(15, L["flameburst_cooldown_warn"], "Positive")
			self:Bar(L["flameburst_cooldown_bar"], 20, "Spell_Fire_BlueRainOfFire")
		end
	elseif msg == L["phase4_trigger"] then
		if self.db.profile.phase then
			self:Message(L["phase4_message"], "Important", nil, "Alarm")
		end
	end
end

function mod:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if msg:find(L["flameburst"]) then
		self:Sync("IliBurst")
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["demons_trigger"] then
		self:Sync("IliDemons")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["enrage_trigger"] then
		self:Sync("IliEnrage")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["phase2_trigger"] then
		self:Sync("IliPhase2")
	end
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss and self.db.profile.phase then
		local hp = UnitHealth(msg)
		if hp > 65 and hp < 70 and not p2Announced then
			self:Message(L["phase2_soon_message"], "Attention")
			p2Announced = true
			for k in pairs(flamed) do flamed[k] = nil end
		elseif hp > 70 and p2Announced then
			p2Announced = nil
		elseif hp > 30 and hp < 35 and not p4Announced then
			self:Message(L["phase4_soon_message"], "Attention")
			p4Announced = true
		elseif hp > 35 and p4Announced then
			p4Announced = nil
		end
	end
end
--[[
function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["caged_trigger"] then
		self:Sync("IliCaged")
	end
end
]]
do
	local flameDies = UNITDIESOTHER:format(L["Flame of Azzinoth"])
	function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
		if msg == flameDies then
			self:Sync("IliFlameDied")
		else
			self:GenericBossDeath(msg)
		end
	end
end

function mod:FlameWarn()
	if self.db.profile.flame then
		local msg = nil
		for k in pairs(flamed) do
			self:Bar(L["flame_message"]:format(k), 60, "Spell_Fire_BlueImmolation")
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["flame_message"]:format(msg), "Important", nil, "Alert")
	end
	for k in pairs(flamed) do flamed[k] = nil end
end

