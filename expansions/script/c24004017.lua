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
	return c:IsFaceupUntapped() and not c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
scard.posop=dm.TapUntapOperation(nil,scard.posfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,nil,POS_FACEUP_TAPPED)