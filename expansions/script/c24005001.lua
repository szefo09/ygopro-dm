--La Byle, Seeker of the Winds
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleBlockEffect(c,0,nil,nil,scard.posop)
end
scard.duel_masters_card=true
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.ChangePosition(c,POS_FACEUP_UNTAPPED)
end
