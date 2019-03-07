--Kuukai, Finder of Karma
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_MECHA_THUNDER))
	--untap
	dm.AddSingleBlockEffect(c,0,nil,nil,dm.SelfTapUntapOperation(POS_FACEUP_UNTAPPED))
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
