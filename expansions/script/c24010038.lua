--Recon Operation
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--confirm
	dm.AddSpellCastEffect(c,0,nil,dm.ConfirmOperation(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SHIELD,0,3))
end
scard.duel_masters_card=true
