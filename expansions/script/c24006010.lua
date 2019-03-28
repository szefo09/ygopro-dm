--Splinterclaw Wasp
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BECOMES_BLOCKED)
	e1:SetOperation(dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1,1,c))
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
