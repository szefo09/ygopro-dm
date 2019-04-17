--Explosive Trooper Zalmez
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.destg,scard.desop,nil,scard.descon)
end
scard.duel_masters_card=true
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetShieldCount(1-tp)<=2
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BATTLE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BATTLE,1)
