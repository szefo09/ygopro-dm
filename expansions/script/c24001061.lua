--Stinger Worm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DestroyOperation(PLAYER_PLAYER,nil,DM_LOCATION_BATTLE,0,1))
end
scard.duel_masters_card=true