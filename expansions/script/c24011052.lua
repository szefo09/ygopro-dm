--Live and Breathe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to battle)
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(DM_EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(dm.PlayerSummonCreatureCondition(tp))
	e1:SetOperation(scard.tbop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.tbfilter(c,e,tp,code)
	return c:IsCreature() and c:IsCode(code) and c:IsCanSendtoBattle(e,0,tp,false,false)
end
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	local code=eg:GetFirst():GetCode()
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBATTLE)
	local g=Duel.SelectMatchingCard(tp,scard.tbfilter,tp,LOCATION_DECK,0,0,1,nil,e,tp,code)
	if g:GetCount()==0 then return end
	Duel.SendtoBattle(g,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
