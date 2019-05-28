--Pippie Kuppie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,1000,nil,DM_LOCATION_BZONE,DM_LOCATION_BZONE,scard.powtg)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_ARMORED_DRAGON)
end
