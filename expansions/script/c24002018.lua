--Plasma Chaser
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BATTLE,nil)>0 end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BATTLE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
