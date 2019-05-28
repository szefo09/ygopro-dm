--ハリケーン・フィッシュ
--Hurricane Fish
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,dm.DrawOperation(PLAYER_SELF,1))
	--return
	dm.AddTurnEndTriggerEffect(c,1,PLAYER_SELF,nil,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.retfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
end
