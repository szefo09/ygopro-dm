--Comet Missile
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,dm.DestroyOperation(PLAYER_PLAYER,scard.desfilter,0,DM_LOCATION_BATTLE,1))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.DestroyOperation(PLAYER_PLAYER,scard.desfilter,0,DM_LOCATION_BATTLE,1))
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_BLOCKER) and c:IsPowerBelow(6000)
end