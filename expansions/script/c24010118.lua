--Terradragon Dakma Balgarow
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,1,scard.tbcon)
end
scard.duel_masters_card=true
--power up
function scard.powval(e,c)
	local ct1=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),c:GetControler(),DM_LOCATION_SHIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),c:GetControler(),0,DM_LOCATION_SHIELD,nil)
	return (ct1+ct2)*2000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(15000)
end
