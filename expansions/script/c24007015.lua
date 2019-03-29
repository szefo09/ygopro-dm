--Rondobil, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to shield)
	dm.EnableTapAbility(c,0,nil,dm.SendtoShieldOperation(PLAYER_SELF,scard.tsfilter,DM_LOCATION_BATTLE,0,1))
end
scard.duel_masters_card=true
function scard.tsfilter(c)
	return c:IsFaceup() and c:IsAbleToShield()
end
