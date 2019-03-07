--King Triumphant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.abcon)
	e1:SetOperation(scard.abop)
	c:RegisterEffect(e1)
	dm.AddPlayerCastSpellEffect(c,0,PLAYER_OPPONENT,nil,nil,scard.abop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp and c:GetSummonType()==DM_SUMMON_TYPE_NORMAL
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--blocker
	dm.GainEffectBlocker(c,c,1)
end
