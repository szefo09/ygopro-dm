--Larba Geer, the Immaculate
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GUARDIAN))
	--tap
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.posop)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped() and c:IsHasEffect(DM_EFFECT_BLOCKER)
end
scard.posop=dm.TapUntapOperation(nil,scard.posfilter,0,DM_LOCATION_BATTLE,nil,nil,POS_FACEUP_TAPPED)
