--Bladerush Skyterror Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,nil,LOCATION_ALL,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR))
end
scard.duel_masters_card=true
