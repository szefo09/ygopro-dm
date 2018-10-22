--Vampire Silphy
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE))
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
