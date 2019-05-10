--Cavern Raider
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleUnblockedAttackEffect(c,0,nil,nil,scard.thop,nil,scard.thcon)
end
scard.duel_masters_card=true
scard.thcon=dm.AttackPlayerCondition
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.IsCreature,LOCATION_DECK,0,0,1,true)
