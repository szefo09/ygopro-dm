--Meteosaur
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BATTLE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BATTLE,1)
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
