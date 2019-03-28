--カンナビス
--Cannabis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--draw
	dm.AddSingleDestroyedEffect(c,0,nil,nil,dm.DrawOperation(PLAYER_SELF,math.random(3)))
end
scard.duel_masters_card=true
