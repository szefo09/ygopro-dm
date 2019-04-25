--Shock Trooper Mykee
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(scard.descon)
	e1:SetTarget(scard.destg)
	e1:SetOperation(scard.desop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsBlocked() and Duel.GetAttackTarget()==nil
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
