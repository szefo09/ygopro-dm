--Sky Crusher, the Agitator
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to grave)
	dm.EnableTapAbility(c,0,scard.tgtg,scard.tgop)
end
scard.duel_masters_card=true
scard.tgtg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_MANA,DM_LOCATION_MANA)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	dm.SendtoGraveOperation(tp,dm.ManaZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_MANA,0,1)(e,tp,eg,ep,ev,re,r,rp)
	dm.SendtoGraveOperation(1-tp,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1)(e,tp,eg,ep,ev,re,r,rp)
end