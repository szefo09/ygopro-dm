--光器ナターリャ
--Natalia, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddPlayerCastSpellEffect(c,0,nil,nil,nil,nil,dm.TapOperation(PLAYER_SELF,Card.IsFaceup,0,DM_LOCATION_BATTLE,1,1,true))
end
scard.duel_masters_card=true
