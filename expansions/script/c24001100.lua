--Pangaea's Song
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoManaOperation(PLAYER_PLAYER,nil,DM_LOCATION_BATTLE,0,1))
end
scard.duel_masters_card=true