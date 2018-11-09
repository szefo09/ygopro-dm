--Toel, Vizier of Hope
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddTurnEndEffect(c,0,PLAYER_PLAYER,true,scard.postg,scard.posop,nil,nil,1)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,DM_LOCATION_BATTLE,0)
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
end
