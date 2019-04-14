--Turtle Horn, the Imposing
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddPlayerUseShieldTriggerEffect(c,0,PLAYER_OPPO,nil,nil,scard.thop)
end
scard.duel_masters_card=true
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	dm.SendtoHandOperation(tp,Card.IsCreature,LOCATION_DECK,0,0,1,true)(e,tp,eg,ep,ev,re,r,rp)
end
