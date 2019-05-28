--Mongrel Man
--Not fully implemented: If this and another creature are destroyed at the same time, you can still trigger its ability.
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddDestroyedTriggerEffect(c,0,true,scard.drtg,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCreature,1,nil)
end
scard.drtg=dm.DrawTarget(PLAYER_SELF)
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
--[[
	Notes
		1. The ability can still trigger if Mongrel Man and another creature are destroyed at the same time
		https://duelmasters.fandom.com/wiki/Mongrel_Man/Rulings
]]
