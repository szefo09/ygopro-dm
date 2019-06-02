--Shock Trooper Mykee
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--destroy
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,true,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
end
scard.duel_masters_card=true
scard.descon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
