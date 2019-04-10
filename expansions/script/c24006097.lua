--Factory Shell Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (search) (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,dm.HintTarget,scard.thop)
	dm.AddStaticEffectSingleComeIntoPlay(c,0,nil,dm.HintTarget,scard.thop,LOCATION_ALL,0,scard.thtg)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.AND(Card.IsAbleToHand,Card.DMIsRace),tp,LOCATION_DECK,0,0,1,nil,DM_RACE_SURVIVOR)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function scard.thtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end