--Sea Slug
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
end
scard.duel_masters_card=true
