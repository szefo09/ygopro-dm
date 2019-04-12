--Dedreen, the Hidden Corrupter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.dhop,nil,scard.dhcon)
end
scard.duel_masters_card=true
function scard.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(dm.ShieldZoneFilter(),tp,0,DM_LOCATION_SHIELD,nil)<=3
end
scard.dhop=dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,1,1,true)
