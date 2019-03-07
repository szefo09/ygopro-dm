--Sphere of Wonder
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield
	dm.AddSpellCastEffect(c,0,nil,scard.tsop)
end
scard.duel_masters_card=true
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),tp,DM_LOCATION_SHIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),tp,0,DM_LOCATION_SHIELD,nil)
	if ct2>ct1 then
		Duel.SendDecktoptoShield(tp,1)
	end
end
