--Slash and Burn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(scard.tgcon)
	e1:SetOperation(scard.tbop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(DM_LOCATION_BATTLE)
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.tgfilter(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(scard.tgfilter),1-tp,DM_LOCATION_MANA,0,1,1,nil,e)
	if g1:GetCount()>0 then
		Duel.SetTargetCard(g1)
		Duel.DMSendtoGrave(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ShieldZoneFilter(scard.tgfilter),1-tp,DM_LOCATION_SHIELD,0,1,1,nil,e)
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SetTargetCard(g2)
		Duel.DMSendtoGrave(g2,REASON_EFFECT)
	end
end
