--Scissor Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,scard.thfilter,LOCATION_DECK,0,0,1,true))
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:DMIsRace(DM_RACE_GIANT_INSECT)
end
