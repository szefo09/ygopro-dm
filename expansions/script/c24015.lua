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
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.posop=dm.TapUntapOperation(PLAYER_PLAYER,scard.posfilter,0,DM_LOCATION_BATTLE,1,1,POS_FACEUP_TAPPED,true)
