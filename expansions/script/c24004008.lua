--Fu Reil, Seeker of Storms
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot use shield trigger
	dm.EnablePlayerEffectCustom(c,EFFECT_CANNOT_ACTIVATE,1,1,scard.actval)
end
scard.duel_masters_card=true
function scard.actval(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsBrokenShield() and rc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) and rc:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
