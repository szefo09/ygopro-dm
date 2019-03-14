--Rumblesaur Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,DM_LOCATION_BATTLE,LOCATION_ALL,0,scard.satg)
end
scard.duel_masters_card=true
function scard.satg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
