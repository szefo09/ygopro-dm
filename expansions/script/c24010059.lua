--Upheaval
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return, to mana
	dm.AddSpellCastEffect(c,0,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.return_card(player)
	local g1=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsAbleToHand),player,DM_LOCATION_MANA,0,nil)
	Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToMana,player,LOCATION_HAND,0,nil)
	g2:Sub(Duel.GetOperatedGroup())
	Duel.SendtoMana(g2,POS_FACEUP_TAPPED,REASON_EFFECT)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	scard.return_card(tp)
	scard.return_card(1-tp)
end
