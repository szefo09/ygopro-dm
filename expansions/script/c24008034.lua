--Scream Slicer, Shadow of Fear
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddComeIntoPlayEffect(c,0,nil,nil,scard.desop,nil,scard.descon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_DRAGO_NOID+DM_RACE_DRAGON)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return end
	local tg=g:GetMinGroup(Card.GetPower)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	else Duel.Destroy(tg,REASON_EFFECT) end
end
