--Cratersaur
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack untapped
	dm.EnableAttackUntapped(c,nil,nil,dm.NoShieldsCondition(PLAYER_PLAYER))
	dm.AddEffectDescription(c,0,dm.NoShieldsCondition(PLAYER_PLAYER))
	--power attacker
	dm.EnablePowerAttacker(c,3000,dm.NoShieldsCondition(PLAYER_PLAYER))
	dm.AddEffectDescription(c,1,dm.NoShieldsCondition(PLAYER_PLAYER))
end
scard.duel_masters_card=true
