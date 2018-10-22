--Ambush Scorpion
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--to battle
	dm.AddSingleDestroyedEffect(c,0,true,scard.tbtg,scard.tbop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tbtg=dm.ChoosePutIntoBattleTarget(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsCode),DM_LOCATION_MANA,0,1,1,nil,sid)
scard.tbop=dm.ChoosePutIntoBattleOperation()
