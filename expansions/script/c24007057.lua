--Cosmic Nebula
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_VIRUS))
	--draw
	dm.AddEventDrawEffect(c,0,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1),nil,scard.drcon)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_VIRUS,DM_RACE_CYBER}
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE
end
