--Toel, Vizier of Hope
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddTurnEndEffect(c,0,PLAYER_SELF,true,scard.postg,scard.posop)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,DM_LOCATION_BATTLE,0)
scard.posop=dm.UntapOperation(nil,scard.posfilter,DM_LOCATION_BATTLE,0)
