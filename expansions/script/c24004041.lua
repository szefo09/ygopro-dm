--Chaotic Skyterror
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,4000,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,scard.abtg)
	--get ability (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,scard.abtg)
end
scard.duel_masters_card=true
scard.abtg=aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_DEMON_COMMAND)
