--La Byle, Seeker of the Winds
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleBlockTriggerEffect(c,0,nil,nil,dm.SelfUntapOperation())
end
scard.duel_masters_card=true
