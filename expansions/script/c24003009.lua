--Sparkle Flower
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (blocker)
	dm.EnableBlocker(c,dm.ManaExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
	dm.AddEffectDescription(c,0,dm.ManaExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
end
scard.duel_masters_card=true
