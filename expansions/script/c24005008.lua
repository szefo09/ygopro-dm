--Gallia Zohl, Iron Guardian Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (blocker)
	dm.EnableBlocker(c)
	dm.AddStaticEffectBlocker(c,LOCATION_ALL,0,scard.bltg)
end
scard.duel_masters_card=true
function scard.bltg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
