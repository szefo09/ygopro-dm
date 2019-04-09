--Metalwing Skyterror
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_BLOCKER)
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
