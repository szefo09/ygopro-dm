--Invincible Cataclysm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_PLAYER,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_SHIELD,0,3,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation