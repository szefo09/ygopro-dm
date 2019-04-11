--Kejila, the Hidden Horror
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--silent skill (break)
	dm.EnableSilentSkill(c,0,scard.brtg,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,2,2,c))
end
scard.duel_masters_card=true
function scard.brtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(dm.ShieldZoneFilter(aux.TRUE),tp,0,DM_LOCATION_SHIELD,1,nil) end
end
