--Necrodragon Zalva
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DrawOperation(PLAYER_OPPO,1))
end
scard.duel_masters_card=true
