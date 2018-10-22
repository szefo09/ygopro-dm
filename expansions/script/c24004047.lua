--Sword of Malevolent Death
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power up
		dm.GainEffectUpdatePower(e:GetHandler(),tc,1,scard.powval,nil,nil,dm.SelfAttackerCondition)
	end
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.ManaZoneFilter(Card.IsCivilization),c:GetControler(),DM_LOCATION_MANA,0,nil,DM_CIVILIZATION_DARKNESS)*1000
end
