--Mystic Inscription
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield
	dm.AddSpellCastEffect(c,0,nil,dm.DecktopSendtoShieldOperation(PLAYER_PLAYER,1))
end
scard.duel_masters_card=true