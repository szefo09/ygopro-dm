--Lucky Ball
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DrawUpToOperation(PLAYER_SELF,2),nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(dm.ShieldZoneFilter(),tp,0,DM_LOCATION_SHIELD,nil)<=3
end
