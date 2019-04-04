--Emperor Maroll
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD))
	--return
	dm.AddComeIntoPlayEffect(c,0,nil,nil,scard.retop1,nil,scard.retcon)
	--no battle (return)
	dm.EnableEffectCustom(c,DM_EFFECT_NO_BE_BLOCKED_BATTLE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BECOMES_BLOCKED)
	e1:SetOperation(scard.retop2)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
--return
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp
end
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.retop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoHand(c,PLAYER_OWNER,REASON_EFFECT)
end
--no battle (return)
function scard.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoHand(Duel.GetBlocker(),PLAYER_OWNER,REASON_EFFECT)
end
