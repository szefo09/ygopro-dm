--Avalanche Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot attack creature
	dm.EnableCannotAttackCreature(c)
	--break
	dm.AddSingleBecomeBlockedEffect(c,0,nil,nil,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1,1,c))
end
scard.duel_masters_card=true
