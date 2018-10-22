--Snork La, Shrine Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(DM_EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.retcon)
	e1:SetOperation(scard.retop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsPreviousLocation(DM_LOCATION_MANA) and c:GetPreviousControler()==tp
end
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(dm.DMGraveFilter(scard.cfilter),1,nil,tp)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoMana(eg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
