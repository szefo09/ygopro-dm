--Raging Dash-Horn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,3000,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_NATURE))
	dm.AddEffectDescription(c,0,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_NATURE))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_NATURE))
	dm.AddEffectDescription(c,1,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_NATURE))
end
scard.duel_masters_card=true
