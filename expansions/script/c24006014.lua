--Bonds of Justice
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
	return c:IsFaceup() and c:IsUntapped() and not c:IsHasEffect(DM_EFFECT_BLOCKER)
end
scard.posop=dm.TapOperation(nil,scard.posfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
