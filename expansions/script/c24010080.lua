--Ancient Horn, the Watcher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),tp,DM_LOCATION_SHIELD,0,nil)>=5
end
scard.posop=dm.TapUntapOperation(nil,dm.ManaZoneFilter(Card.IsTapped),0,DM_LOCATION_MANA,nil,nil,POS_FACEUP_UNTAPPED)
