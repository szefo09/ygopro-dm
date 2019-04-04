--Petrova, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.abop)
	--cannot be targeted
	dm.EnableCannotBeTargeted(c)
end
scard.duel_masters_card=true
--function used to find a particular item in a list
local function tablefind(t,el)
	for i,v in pairs(t) do
		if v==el then
			return i
		end
	end
end
--get ability
function scard.abfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local t1=dm.race_desc_list
	local t2=dm.race_value_list
	local item1=tablefind(t1,DM_SELECT_RACE_MECHA_DEL_SOL)
	local item2=tablefind(t2,DM_RACE_MECHA_DEL_SOL)
	table.remove(t1,item1)
	table.remove(t2,item2)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	table.insert(t1,1,DM_SELECT_RACE_MECHA_DEL_SOL)
	table.insert(t2,1,DM_RACE_MECHA_DEL_SOL)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,race)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(e:GetHandler(),tc,1,4000,0,0)
	end
end
