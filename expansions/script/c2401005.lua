--ガルベリアス・ドラゴン
--Galberius Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.tmop,nil,scard.tmcon)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,nil,scard.actcon)
	--slayer
	dm.EnableSlayer(c,scard.slcon)
	--untap
	dm.EnableTurnEndSelfUntap(c,1,scard.poscon)
end
scard.duel_masters_card=true
function scard.cfilter(c,civ)
	return c:IsFaceup() and c:IsCivilization(civ)
end
--to mana
function scard.tmcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),0,DM_LOCATION_BATTLE,1,nil,DM_CIVILIZATION_NATURE)
end
scard.tmop=dm.DecktopSendtoManaOperation(PLAYER_PLAYER,1)
--cannot be blocked
function scard.actcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),0,DM_LOCATION_BATTLE,1,nil,DM_CIVILIZATION_WATER)
end
--slayer
function scard.slcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),0,DM_LOCATION_BATTLE,1,nil,DM_CIVILIZATION_DARKNESS)
end
--untap
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,0,DM_LOCATION_BATTLE,1,nil,DM_CIVILIZATION_LIGHT)
end
