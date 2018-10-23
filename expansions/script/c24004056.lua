--Rimuel, Cloudbreak Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.posop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsUntapped() and c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(scard.cfilter),tp,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local g=Duel.SelectMatchingCard(tp,Card.IsUntapped,tp,0,DM_LOCATION_BATTLE,ct,ct,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.ChangePosition(g,POS_FACEUP_TAPPED)
end