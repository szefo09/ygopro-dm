--Obsidian Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--to battle
	dm.AddSingleDestroyedEffect(c,0,true,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
scard.tbtg=dm.PutIntoBattleTarget(dm.ManaZoneFilter(Card.IsCode),DM_LOCATION_MANA,0,nil,sid)
scard.tbop=dm.PutIntoBattleOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsCode),DM_LOCATION_MANA,0,1,1,nil,nil,sid)
