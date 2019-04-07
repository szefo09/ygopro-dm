--Sabermask Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MANA,0,1))
end
scard.duel_masters_card=true
