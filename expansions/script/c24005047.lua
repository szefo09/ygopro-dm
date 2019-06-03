--Balloonshroom Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (destroy replace) (to mana)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetTarget(scard.reptg)
	e1:SetOperation(scard.repop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BZONE)
	e2:SetTargetRange(LOCATION_ALL,0)
	e2:SetTarget(dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToMZone)
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoMZone(c,POS_FACEUP_UNTAPPED,REASON_EFFECT+REASON_REPLACE)
end
