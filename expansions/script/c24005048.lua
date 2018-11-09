--Bloodwing Mantis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0,2))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
