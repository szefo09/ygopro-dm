--Mulch Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoManaOperation(PLAYER_SELF,scard.tmfilter,DM_LOCATION_BATTLE,0,1))
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMana()
end
