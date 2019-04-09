--Sanfist, the Savage Vizier
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--discard replace (to battle)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(dm.TurnPlayerCondition(PLAYER_OPPO))
	e1:SetTarget(scard.reptg)
	e1:SetOperation(scard.repop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_DISCARD) and c:IsCanSendtoBattle(e,0,tp,false,false) end
	return Duel.SelectYesNo(tp,aux.Stringid(sid,1))
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoBattle(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
