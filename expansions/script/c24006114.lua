--Q-tronic Hypermind
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SURVIVOR))
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.drtg,scard.drop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_SURVIVOR)
end
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)>0 end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
