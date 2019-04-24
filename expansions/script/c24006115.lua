--Daidalos, General of Fury
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack cost (destroy)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(scard.atcost)
	e1:SetOperation(scard.atop)
	c:RegisterEffect(e1)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function scard.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BATTLE,0,1,e:GetHandler())
end
function scard.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,scard.cfilter,tp,DM_LOCATION_BATTLE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
	Duel.AttackCostPaid()
end
