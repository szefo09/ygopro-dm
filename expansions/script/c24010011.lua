--Berochika, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.tsop,nil,scard.tscon)
end
scard.duel_masters_card=true
function scard.tscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetShieldCount(tp)>=5
end
scard.tsop=dm.DecktopSendtoShieldOperation(PLAYER_SELF,1)
