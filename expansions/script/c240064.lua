--Star-Cry Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,3000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:DMIsRace(DM_RACE_ARMORED_DRAGON)
end
