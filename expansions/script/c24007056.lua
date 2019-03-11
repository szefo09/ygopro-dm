--Siri, Glory Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--blocker
	dm.EnableBlocker(c,dm.NoShieldsCondition(PLAYER_PLAYER))
	dm.AddEffectDescription(c,1,dm.NoShieldsCondition(PLAYER_PLAYER))
	--untap
	dm.EnableTurnEndSelfUntap(c,0,dm.NoShieldsCondition(PLAYER_PLAYER))
	dm.AddEffectDescription(c,2,dm.NoShieldsCondition(PLAYER_PLAYER))
end
scard.duel_masters_card=true
