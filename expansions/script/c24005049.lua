--Brutal Charge
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to hand)
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.thfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(scard.thfilter,1,nil) then
		local ct=Duel.GetBrokenShieldCount(tp)
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,scard.thfilter,0,ct,nil)
		if sg:GetCount()==0 then return Duel.ShuffleDeck(tp) end
		Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.Hint(HINT_MESSAGE,tp,DM_HINTMSG_NOTARGETS)
		Duel.ShuffleDeck(tp)
	end
end
