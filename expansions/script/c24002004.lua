--Laguna, Lightning Enforcer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_PLAYER,Card.IsSpell,LOCATION_DECK,0,0,1,true))
end
scard.duel_masters_card=true
