--光器ナターリャ
--Natalia, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddPlayerCastSpellEffect(c,0,nil,nil,nil,scard.posop)
end
scard.duel_masters_card=true
scard.posop=dm.TapUntapOperation(PLAYER_PLAYER,Card.IsUntapped,0,DM_LOCATION_BATTLE,1,1,POS_FACEUP_TAPPED,true)
