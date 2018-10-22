--Toel, Vizier of Hope
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddTurnEndEffect(c,0,true,scard.postg,scard.posop,nil,dm.TurnPlayerCondition(PLAYER_PLAYER))
end
scard.duel_masters_card=true
scard.postg=dm.CheckCardFunction(Card.IsTapped,DM_LOCATION_BATTLE,0)
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsTapped,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
end
