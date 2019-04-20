--天恵の精霊アステリア
--Asteria, Spirit of Heaven's Blessing
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DRAW)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.drcon)
	e1:SetOperation(scard.drop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r~=REASON_RULE
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
