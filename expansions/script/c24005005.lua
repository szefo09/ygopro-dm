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
	dm.AddSingleDestroyedTriggerEffect(c,0,true,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
function scard.tbfilter(c)
	return c:IsCode(CARD_OBSIDIAN_SCARAB)
end
scard.tbtg=dm.SendtoBattleTarget(dm.ManaZoneFilter(scard.tbfilter),DM_LOCATION_MZONE,0)
scard.tbop=dm.SendtoBattleOperation(PLAYER_SELF,dm.ManaZoneFilter(scard.tbfilter),DM_LOCATION_MZONE,0,1)
