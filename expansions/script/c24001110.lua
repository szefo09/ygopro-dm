--Ultimate Force
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,dm.DecktopSendtoManaOperation(PLAYER_SELF,2))
end
scard.duel_masters_card=true
