--Illusionary Merfolk
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_CYBER_LORD)
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BATTLE,0,1,nil)
end
scard.drop=dm.DrawUpToOperation(PLAYER_SELF,3)
