--Totto Pipicchi
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,DM_LOCATION_BATTLE,0,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_DRAGON))
end
scard.duel_masters_card=true
