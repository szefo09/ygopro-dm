--Hydrooze, the Mutant Emperor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,scard.evofilter)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--get ability (cannot be blocked)
	dm.AddStaticEffectCannotBeBlocked(c,DM_LOCATION_BATTLE,0,scard.acttg)
end
scard.duel_masters_card=true
--evolution
function scard.evofilter(c)
	return c:DMIsEvolutionRace(DM_RACE_CYBER_LORD) or c:DMIsEvolutionRace(DM_RACE_HEDRIAN)
end
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and (c:DMIsRace(DM_RACE_CYBER_LORD) or c:DMIsRace(DM_RACE_HEDRIAN))
end
--get ability (cannot be blocked)
function scard.acttg(e,c)
	return c:IsFaceup() and (c:DMIsRace(DM_RACE_CYBER_LORD) or c:DMIsRace(DM_RACE_HEDRIAN))
end