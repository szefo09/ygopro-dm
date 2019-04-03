--Venom Worm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (get ability)
	dm.EnableTapAbility(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMChooseRace(tp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,race)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--slayer
		dm.RegisterEffectSlayer(e:GetHandler(),tc,1)
	end
end
