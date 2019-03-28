--Liquid Scope
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--confirm
	dm.AddSpellCastEffect(c,0,nil,scard.confop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.confop)
end
scard.duel_masters_card=true
function scard.conffilter(c)
	return (c:IsShield() and c:IsFacedown()) or (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
end
scard.confop=dm.ConfirmOperation(PLAYER_SELF,scard.conffilter,0,LOCATION_HAND+DM_LOCATION_SHIELD)
