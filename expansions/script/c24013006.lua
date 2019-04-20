--宣凶師ドロシア
--Dorothea, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.drcon)
	e1:SetOperation(scard.drop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.NOT(Card.IsReason),1,nil,REASON_RULE) and Duel.GetTurnPlayer()~=tp and ep==tp
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local ct=eg:FilterCount(aux.NOT(Card.IsReason),nil,REASON_RULE)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
--[[
	References
		1. Magical Thorn
		https://github.com/Fluorohydride/ygopro-scripts/blob/b1e1b6a/c53119267.lua#L22
]]
