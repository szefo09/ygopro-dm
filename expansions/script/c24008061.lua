--スケルトン･バイス
--Skeleton Vice
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,LOCATION_HAND,0,2,2,true))
end
scard.duel_masters_card=true
