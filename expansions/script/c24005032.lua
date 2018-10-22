--Skullsweeper Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (discard)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(DM_EFFECT_FLAG_ATTACK_TRIGGER+DM_EFFECT_FLAG_CARD_CHOOSE)
	e1:SetTarget(scard.dhtg)
	e1:SetOperation(dm.ChooseDiscardOperation)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATIONS_ALL,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsDMRace,DM_RACE_SURVIVOR))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DISCARD)
	Duel.SelectTarget(1-tp,nil,1-tp,LOCATION_HAND,0,1,1,nil)
end
