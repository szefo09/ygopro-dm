--Hopeless Vortex
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,dm.DestroyOperation(PLAYER_PLAYER,Card.IsFaceup,0,DM_LOCATION_BATTLE,1))
end
scard.duel_masters_card=true
