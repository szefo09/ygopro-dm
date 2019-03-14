--Supporting Tulip
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,4000,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_ANGEL_COMMAND))
end
scard.duel_masters_card=true
