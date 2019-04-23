--Headlong Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,dm.NoHandCondition(PLAYER_SELF))
	dm.AddEffectDescription(c,1,dm.NoHandCondition(PLAYER_SELF))
	--attack cost (discard)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(scard.atcost)
	e1:SetOperation(scard.atop)
	c:RegisterEffect(e1)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsPowerBelow,4000))
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
function scard.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function scard.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST)
	Duel.AttackCostPaid()
end
--[[
	References
		1. The Dragon's Bead
		https://github.com/Fluorohydride/ygopro-scripts/blob/f24eb49/c92408984.lua#L37
]]
