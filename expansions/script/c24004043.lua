--Magmarex
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPower(1000)
end
scard.desop=dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
