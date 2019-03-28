--Enchanted Soil
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoManaOperation(PLAYER_SELF,dm.DMGraveFilter(scard.tmfilter),DM_LOCATION_GRAVE,0,0,2))
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsCreature() and c:IsAbleToMana()
end
