--Nexus Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoShieldOperation(PLAYER_SELF,Card.IsAbleToShield,LOCATION_HAND,0,1))
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true