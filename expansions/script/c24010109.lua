--Sanfist, the Savage Vizier
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--discard replace (to battle)
	dm.AddSingleDiscardReplaceEffect(c,0,scard.reptg,scard.repop,dm.TurnPlayerCondition(PLAYER_OPPO))
end
scard.duel_masters_card=true
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_DISCARD) and not c:IsReason(REASON_REPLACE)
		and c:IsCanSendtoBattle(e,0,tp,false,false) end
	return Duel.SelectYesNo(tp,aux.Stringid(sid,1))
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoBattle(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
