--Enchanted Soil
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
scard.tmop=dm.SendtoManaOperation(PLAYER_PLAYER,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,0,2)
