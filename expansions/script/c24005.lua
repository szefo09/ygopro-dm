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
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.tmop,nil,scard.abcon(DM_CIVILIZATION_NATURE))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,nil,scard.abcon(DM_CIVILIZATION_WATER))
	--slayer
	dm.EnableSlayer(c,scard.abcon(DM_CIVILIZATION_DARKNESS))
	--untap
	dm.EnableTurnEndSelfUntap(c,1,scard.poscon)
end
scard.duel_masters_card=true
function scard.cfilter(c,civ)
	return c:IsFaceup() and c:IsCivilization(civ)
end
function scard.abcon(civ)
	return	function(e)
				return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),0,DM_LOCATION_BATTLE,1,nil,civ)
			end
end
--to mana
scard.tmop=dm.DecktopSendtoManaOperation(PLAYER_SELF,1)
--untap
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,0,DM_LOCATION_BATTLE,1,nil,DM_CIVILIZATION_LIGHT)
end
