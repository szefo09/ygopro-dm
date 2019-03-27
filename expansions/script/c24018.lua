--ハリケーン・フィッシュ
--Hurricane Fish
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DrawOperation(PLAYER_PLAYER,1))
	--return
	dm.AddTurnEndEffect(c,1,PLAYER_PLAYER,nil,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(scard.retfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
end
