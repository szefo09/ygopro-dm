--Aqua Grappler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BZONE,0,1,e:GetHandler()) end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,e:GetHandler())
	Duel.Draw(tp,ct,REASON_EFFECT)
end
