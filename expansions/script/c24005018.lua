--Lurking Eel
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c,dm.CivilizationBlockerCondition(DM_CIVILIZATIONS_FN),DM_DESC_FIRE_NATURE_BLOCKER)
end
scard.duel_masters_card=true
