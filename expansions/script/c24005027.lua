--Gigaling Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (slayer)
	dm.EnableSlayer(c)
	dm.AddStaticEffectSlayer(c,LOCATION_ALL,0,scard.sltg)
end
scard.duel_masters_card=true
function scard.sltg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
