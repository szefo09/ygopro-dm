--Neon Cluster
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (draw)
	dm.EnableTapAbility(c,0,dm.DrawTarget(PLAYER_PLAYER),dm.DrawOperation(PLAYER_PLAYER,2))
end
scard.duel_masters_card=true
