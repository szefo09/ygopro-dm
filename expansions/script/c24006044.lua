--Ripple Lotus Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (tap)
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(scard.postg)
	e1:SetOperation(scard.posop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATION_ALL,0)
	e2:SetTarget(scard.abtg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
function scard.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_BATTLE) and chkc:IsControler(1-tp) and scard.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.posfilter,0,DM_LOCATION_BATTLE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	Duel.SelectTarget(tp,scard.posfilter,tp,0,DM_LOCATION_BATTLE,1,1,nil)
end
scard.posop=dm.TargetTapUntapOperation(POS_FACEUP_TAPPED)
function scard.abtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
