--Pierr, Psycho Doll
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--block if able
	dm.EnableEffectCustom(c,DM_EFFECT_MUST_BLOCK)
	--cannot attack
	dm.EnableCannotAttack(c)
	--slayer
	dm.EnableSlayer(c)
end
scard.duel_masters_card=true
