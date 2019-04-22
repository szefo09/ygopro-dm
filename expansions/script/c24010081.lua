--Bubble Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard & get ability
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.dhcon)
	e1:SetTarget(scard.dhtg)
	e1:SetOperation(scard.dhop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.dhcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsFaceup() and d:IsControler(tp)
end
scard.dhtg=dm.CheckCardFunction(aux.TRUE,LOCATION_HAND,0)
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)==0 then return end
	--power up
	dm.RegisterEffectUpdatePower(c,Duel.GetAttackTarget(),1,3000)
end
