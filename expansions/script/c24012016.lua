--Agira, the Warlord Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,scard.evofilter)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--draw
	dm.AddBlockEffect(c,0,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1),nil,scard.drcon)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GLADIATOR,DM_RACE_EARTH_EATER}
--evolution
function scard.evofilter(c)
	return c:DMIsEvolutionRace(DM_RACE_GLADIATOR) or c:DMIsEvolutionRace(DM_RACE_EARTH_EATER)
end
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and (c:DMIsRace(DM_RACE_GLADIATOR) or c:DMIsRace(DM_RACE_EARTH_EATER))
end
--draw
function scard.cfilter(c)
	return c:IsFaceup() and (c:DMIsRace(DM_RACE_GLADIATOR) or c:DMIsRace(DM_RACE_EARTH_EATER))
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
