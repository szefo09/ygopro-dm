--Hurlosaur
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BATTLE,1))
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(1000)
end
