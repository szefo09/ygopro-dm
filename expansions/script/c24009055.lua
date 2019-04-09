--Whispering Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.thop)
end
scard.duel_masters_card=true
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.IsCode,LOCATION_DECK,0,0,1,true,nil,CARD_WHISPERING_TOTEM)
