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
	return Duel.GetShieldCount(tp)>=5
end
scard.posop=dm.UntapOperation(nil,dm.ManaZoneFilter(Card.IsTapped),DM_LOCATION_MANA,0)
