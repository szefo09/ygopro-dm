--ピクシー・コクーン
--Pixie Cocoon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop)
	--charge
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGE_TAPPED)
end
scard.duel_masters_card=true
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(Card.IsCreature),DM_LOCATION_MANA,0,1)