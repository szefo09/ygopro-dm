--アストラル・リーフ
--Astral Reef
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_CYBER_VIRUS))
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
scard.drtg=dm.DrawTarget(PLAYER_PLAYER)
scard.drop=dm.DrawOperation(PLAYER_PLAYER,3)
