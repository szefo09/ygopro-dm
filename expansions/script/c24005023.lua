--Spikestrike Ichthys Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (cannot be blocked)
	dm.EnableCannotBeBlocked(c)
	dm.AddStaticEffectCannotBeBlocked(c,LOCATION_ALL,0,scard.acttg)
end
scard.duel_masters_card=true
function scard.acttg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
