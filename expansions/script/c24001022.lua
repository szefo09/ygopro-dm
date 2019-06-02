--Toel, Vizier of Hope
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddTriggerEffect(c,0,EVENT_PHASE+PHASE_END,true,scard.postg,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
scard.poscon=dm.TurnPlayerCondition(PLAYER_SELF)
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToUntap()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,DM_LOCATION_BZONE,0)
scard.posop=dm.UntapOperation(nil,scard.posfilter,DM_LOCATION_BZONE,0)
