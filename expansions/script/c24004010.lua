--Gulan Rias, Speed Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,dm.CannotBeAttackedCivValue(DM_CIVILIZATION_DARKNESS))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedCivValue(DM_CIVILIZATION_DARKNESS))
end
scard.duel_masters_card=true
