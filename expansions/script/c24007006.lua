--Bex, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c,dm.NoShieldsCondition(PLAYER_PLAYER))
	dm.AddEffectDescription(c,0,dm.NoShieldsCondition(PLAYER_PLAYER))
end
scard.duel_masters_card=true
