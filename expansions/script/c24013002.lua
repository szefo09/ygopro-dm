--雷炎賢者エイジス
--Aegis, Sage of Fire and Lightning
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--destroy
	dm.AddSingleBlockTriggerEffect(c,0,nil,scard.destg,scard.desop,nil,dm.SelfBattleWinCondition)
end
scard.duel_masters_card=true
function scard.desfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	e:SetLabel(bc:DMGetRace())
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
