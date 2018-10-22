--Mongrel Man
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddDestroyedEffect(c,0,true,scard.drtg,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,DM_LOCATION_BATTLE)
end
scard.drtg=dm.DrawTarget(PLAYER_PLAYER)
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
