--Screaming Sunburst
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,nil,scard.posop)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped() and not c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
scard.posop=dm.TapOperation(nil,scard.posfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
