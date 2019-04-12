--Zaltan
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard & return
	dm.AddComeIntoPlayEffect(c,0,true,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET,scard.dhcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_CYBER_VIRUS)
end
function scard.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
scard.dhtg=dm.CheckCardFunction(aux.TRUE,LOCATION_HAND,0)
function scard.retfilter(c,e)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local ct=Duel.DiscardHand(tp,aux.TRUE,1,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,scard.retfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,ct,ct,nil,e)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
end
