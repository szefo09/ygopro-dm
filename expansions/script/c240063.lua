--Gigagrax
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleDestroyedEffect(c,0,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
scard.destg=dm.CheckCardFunction(Card.IsFaceup,0,DM_LOCATION_BATTLE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,Card.IsFaceup,0,DM_LOCATION_BATTLE,1)
