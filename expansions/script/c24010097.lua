--Estol, Vizier of Aqua
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield & confirm
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.tsop)
end
scard.duel_masters_card=true
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendDecktoptoShield(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsFacedown),tp,0,DM_LOCATION_SHIELD,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.HintSelection(g)
	Duel.ConfirmCards(tp,g)
end
