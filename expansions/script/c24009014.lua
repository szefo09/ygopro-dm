--Tra Rion, Penumbra Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (untap)
	dm.EnableTapAbility(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(race)
	e1:SetCondition(scard.poscon)
	e1:SetOperation(scard.posop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.posfilter(c,race)
	return c:IsFaceup() and c:IsTapped() and c:DMIsRace(race)
end
function scard.poscon(e)
	return Duel.IsExistingMatchingCard(scard.posfilter,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,nil,e:GetLabel())
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,e:GetLabel())
	Duel.Hint(HINT_CARD,0,sid)
	Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
end