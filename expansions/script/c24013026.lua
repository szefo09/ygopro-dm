--妖魔賢者メルカプ
--Melcap, the Mutant Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(scard.poscon)
	e1:SetOperation(dm.TapOperation(nil,scard.posfilter,0,DM_LOCATION_BATTLE))
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsBlocked() and Duel.GetAttackTarget()==nil
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
