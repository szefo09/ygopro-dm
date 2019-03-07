--Rumblesaur Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,DM_LOCATION_BATTLE,LOCATIONS_ALL,LOCATIONS_ALL,scard.satg)
end
scard.duel_masters_card=true
scard.satg=aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_SURVIVOR)
