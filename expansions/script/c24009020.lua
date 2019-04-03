--Kelp Candle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--to hand
	dm.AddSingleBlockEffect(c,0,nil,nil,scard.thop)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	Duel.DisableShuffleCheck()
	Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	dm.SortDeck(tp,tp,3,DECK_SEQUENCE_BOTTOM)
end