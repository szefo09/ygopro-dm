--Nemonex, Bajula's Robomantis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_XENOPARTS,DM_RACE_GIANT_INSECT))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--to grave
	dm.AddUnblockedAttackEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET,scard.tgcon)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_XENOPARTS,DM_RACE_GIANT_INSECT,DM_RACE_GIANT}
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:DMIsRace(DM_RACE_XENOPARTS,DM_RACE_GIANT_INSECT)
end
--to grave
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and a:DMIsRace(DM_RACE_XENOPARTS,DM_RACE_GIANT_INSECT) and Duel.GetAttackTarget()==nil
end
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
