--Shock Trooper Mykee
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--destroy
	dm.AddSingleUnblockedAttackEffect(c,0,true,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
end
scard.duel_masters_card=true
scard.descon=dm.AttackPlayerCondition
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
