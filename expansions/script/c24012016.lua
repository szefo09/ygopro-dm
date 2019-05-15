--Agira, the Warlord Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GLADIATOR,DM_RACE_EARTH_EATER))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--draw
	dm.AddBlockEffect(c,0,true,scard.drtg,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GLADIATOR,DM_RACE_EARTH_EATER}
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:DMIsRace(DM_RACE_GLADIATOR,DM_RACE_EARTH_EATER)
end
--draw
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_GLADIATOR,DM_RACE_EARTH_EATER)
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
scard.drtg=dm.DrawTarget(PLAYER_SELF)
scard.drop=dm.DrawOperation(PLAYER_SELF,1)
