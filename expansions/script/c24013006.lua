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
	e1:SetCondition(aux.AND(dm.EventPlayerCondition(PLAYER_SELF),dm.TurnPlayerCondition(PLAYER_OPPO)))
	e1:SetOperation(scard.drop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
