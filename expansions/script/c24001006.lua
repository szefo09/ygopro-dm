--Holy Awe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--tap
	dm.AddSpellCastEffect(c,0,nil,scard.posop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.posop)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.posop=dm.TapUntapOperation(nil,scard.posfilter,0,DM_LOCATION_BATTLE,nil,nil,POS_FACEUP_TAPPED)
