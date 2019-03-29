--Gigastand
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (return & discard)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget2(1,Card.IsAbleToHand)
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	if Duel.SendtoHand(e:GetHandler(),PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)==0 then return end
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)
end
