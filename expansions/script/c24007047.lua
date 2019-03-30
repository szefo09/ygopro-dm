--Cryptic Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot use shield trigger
	dm.EnablePlayerEffectCustom(c,EFFECT_CANNOT_ACTIVATE,0,1,scard.actval,dm.SelfTappedCondition)
end
scard.duel_masters_card=true
function scard.actval(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsBrokenShield() and rc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER)
end
