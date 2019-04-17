--Solar Grass
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--turbo rush
	dm.EnableTurboRush(c,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--untap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(scard.poscon)
	e1:SetOperation(scard.posop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsBlocked() and Duel.GetAttackTarget()==nil
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsTapped() and not c:IsCode(CARD_SOLAR_GRASS)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Untap(g,REASON_EFFECT)
end
