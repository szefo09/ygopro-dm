--Energy Stream
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,dm.DrawUpToOperation(PLAYER_PLAYER,2))
end
scard.duel_masters_card=true
