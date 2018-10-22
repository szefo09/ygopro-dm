--Rainbow Stone
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to mana)
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoManaOperation(PLAYER_PLAYER,nil,LOCATION_DECK,0,0,1))
end
scard.duel_masters_card=true
