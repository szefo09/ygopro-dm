--Snip Striker Bullraizer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,DM_LOCATION_BATTLE)>Duel.GetFieldGroupCount(tp,DM_LOCATION_BATTLE,0)
end
