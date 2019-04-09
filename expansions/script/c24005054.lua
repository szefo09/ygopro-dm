--Scissor Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.thop)
end
scard.duel_masters_card=true
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.DMIsRace,LOCATION_DECK,0,0,1,true,nil,DM_RACE_GIANT_INSECT)
