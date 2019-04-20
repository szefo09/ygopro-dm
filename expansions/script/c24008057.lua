--Emperor Quazla
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD))
	--draw
	dm.AddPlayerUseShieldTriggerEffect(c,0,PLAYER_OPPO,nil,nil,scard.drop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_LORD,DM_RACE_CYBER}
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.DrawUpTo(tp,2,REASON_EFFECT)
end
