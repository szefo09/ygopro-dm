--King Oquanos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
end
scard.duel_masters_card=true
--power up
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.ManaZoneFilter(Card.IsTapped),c:GetControler(),0,DM_LOCATION_MZONE,nil)*2000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
