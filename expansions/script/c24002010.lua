--Spiral Grass
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleTriggerEffectCustom(c,0,DM_EVENT_BATTLE_END,nil,nil,dm.SelfUntapOperation(),nil,dm.SelfBlockCondition)
end
scard.duel_masters_card=true
