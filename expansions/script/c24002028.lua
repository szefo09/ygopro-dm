--Gigastand
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (return & discard)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) end
	if e:GetHandler():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(sid,1)) then
		Duel.Hint(HINT_CARD,0,sid)
		return true
	else return false end
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoHand(e:GetHandler(),PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)==0 then return end
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
end
