--Slaphappy Soldier Galback
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--turbo rush
	dm.EnableTurboRush(c,scard.abop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(4000)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
	e1:SetTarget(dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BATTLE))
	e1:SetOperation(dm.DestroyOperation(tp,scard.desfilter,0,DM_LOCATION_BATTLE,1))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
