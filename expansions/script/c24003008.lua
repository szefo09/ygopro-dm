--Sieg Balicula, the Intense
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_INITIATE))
	--get ability (blocker)
	dm.AddStaticEffectBlocker(c,DM_LOCATION_BATTLE,0,scard.bltg)
end
scard.duel_masters_card=true
function scard.bltg(e,c)
	return c~=e:GetHandler() and c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
