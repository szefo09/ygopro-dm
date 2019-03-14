--Blazosaur Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (power attacker)
	dm.EnablePowerAttacker(c,1000)
	dm.AddStaticEffectPowerAttacker(c,1000,LOCATION_ALL,0,scard.patg)
end
scard.duel_masters_card=true
function scard.patg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
