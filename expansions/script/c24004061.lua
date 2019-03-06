--アストラル・リーフ
--Astral Reef
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_VIRUS))
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,true,dm.DrawTarget(PLAYER_PLAYER),dm.DrawOperation(PLAYER_PLAYER,3))
end
scard.duel_masters_card=true
