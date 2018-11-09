--Earthstomp Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
