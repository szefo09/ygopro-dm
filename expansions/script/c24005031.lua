--Scheming Hands
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DISCARD)
	local sg=g:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(sg)
	Duel.DMSendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
end
