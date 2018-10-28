--Bladerush Skyterror Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,nil,DM_LOCATION_BATTLE,LOCATIONS_ALL,LOCATIONS_ALL,scard.dbtg)
end
scard.duel_masters_card=true
scard.dbtg=aux.TargetBoolFunction(Card.IsDMRace,DM_RACE_SURVIVOR)
