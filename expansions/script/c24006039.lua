--Mystic Dreamscape
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsAbleToHand),DM_LOCATION_MANA,0,0,3))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsAbleToHand),DM_LOCATION_MANA,0,0,3))
end
scard.duel_masters_card=true
