--Mana Crisis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
	dm.AddShieldTriggerCastEffect(c,0,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tgtg=dm.ChooseCardFunction(PLAYER_PLAYER,dm.ManaZoneFilter(),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.ChooseSendtoGraveOperation