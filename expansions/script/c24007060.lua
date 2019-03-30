--Headlong Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,dm.NoHandCondition(PLAYER_SELF))
	dm.AddEffectDescription(c,1,dm.NoHandCondition(PLAYER_SELF))
	--discard
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,dm.DiscardOperation(PLAYER_SELF,aux.TRUE,LOCATION_HAND,0,1))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsPowerBelow,4000))
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
