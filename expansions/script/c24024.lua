--無規律の超人 (エントロピー・ジャイアント)
--Entropy Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--untap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetOperation(dm.SelfUntapOperation(true))
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
