--Mana Nexus
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoSZoneOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0,1))
end
scard.duel_masters_card=true
