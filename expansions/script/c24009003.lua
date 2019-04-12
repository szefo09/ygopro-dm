--Azaghast, Tyrant of Shadows
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DARK_LORD))
	--destroy
	dm.AddComeIntoPlayEffect(c,0,true,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_GHOST)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Destroy(tc,REASON_EFFECT)
end
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
