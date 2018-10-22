--Whisking Whirlwind
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--untap
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(scard.poscon)
	e1:SetOperation(scard.posop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.poscon(e)
	return Duel.IsExistingMatchingCard(Card.IsTapped,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,nil)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsTapped,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
end
