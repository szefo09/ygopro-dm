--Marrow Ooze, the Twister
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER)
	e1:SetOperation(dm.SelfDestroyOperation())
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
