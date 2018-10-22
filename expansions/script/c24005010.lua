--Kulus, Soulshine Enforcer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.tmop,nil,scard.tmcon)
end
scard.duel_masters_card=true
function scard.tmcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,nil)
	local ct2=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),tp,0,DM_LOCATION_MANA,nil)
	return ct1<ct2
end
scard.tmop=dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1)
