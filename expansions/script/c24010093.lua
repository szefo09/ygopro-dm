--Terradragon Cusdalf
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,4000)
	--double breaker
	dm.EnableBreaker(c)
	--cannot untap
	dm.EnableEffectCustom(c,DM_EFFECT_CANNOT_CHANGE_POS_ABILITY,scard.abcon,DM_LOCATION_MANA,0,scard.abtg)
end
scard.duel_masters_card=true
function scard.abcon(e)
	return Duel.CheckEvent(DM_EVENT_UNTAP_STEP)
end
scard.abtg=aux.TargetBoolFunction(Card.IsTapped)
