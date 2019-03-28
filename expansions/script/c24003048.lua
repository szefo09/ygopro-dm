--Mana Nexus
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to shield
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoShieldOperation(PLAYER_SELF,dm.ManaZoneFilter(Card.IsAbleToShield),DM_LOCATION_MANA,0,1))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.SendtoShieldOperation(PLAYER_SELF,dm.ManaZoneFilter(Card.IsAbleToShield),DM_LOCATION_MANA,0,1))
end
scard.duel_masters_card=true
