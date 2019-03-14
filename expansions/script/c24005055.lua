--Smash Horn Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (power up)
	dm.EnableUpdatePower(c,1000)
	dm.AddStaticEffectUpdatePower(c,1000,LOCATION_ALL,0,scard.powtg)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
