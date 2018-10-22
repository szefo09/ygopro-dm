--Bloodwing Mantis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,scard.retop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsCreature),DM_LOCATION_MANA,0,2)
