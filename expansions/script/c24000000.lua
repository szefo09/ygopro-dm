--Duel Masters Rules
--Not fully implemented: Monster must change to defense mode for attack cost
--Not fully implemented: "Destroy a monster by battle" does not apply if monster is destroyed by rule
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	--apply
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATIONS_ALL-DM_LOCATION_RULES)
	e1:SetCountLimit(1,sid+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(scard.condition)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
	--untap
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetDescription(aux.Stringid(sid,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(DM_LOCATION_RULES)
	e2:SetCondition(scard.poscon1)
	e2:SetOperation(scard.posop1)
	c:RegisterEffect(e2)
	--charge
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetDescription(aux.Stringid(sid,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(DM_LOCATION_RULES)
	e3:SetCountLimit(1)
	e3:SetCondition(scard.tmcon)
	e3:SetOperation(scard.tmop)
	c:RegisterEffect(e3)
	--summoning sickness
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(DM_LOCATION_RULES)
	e4:SetCondition(scard.regcon1)
	e4:SetOperation(scard.regop1)
	c:RegisterEffect(e4)
	--chain limit
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(DM_LOCATION_RULES)
	e5:SetOperation(scard.chop)
	c:RegisterEffect(e5)
	--attack cost workaround
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(DM_LOCATION_RULES)
	e6:SetCondition(scard.poscon2)
	e6:SetOperation(scard.posop2)
	c:RegisterEffect(e6)
	--attack player
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetRange(DM_LOCATION_RULES)
	e7:SetTargetRange(DM_LOCATION_BATTLE,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsCanAttackPlayer))
	c:RegisterEffect(e7)
	--destroy 0 power
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(DM_LOCATION_RULES)
	e8:SetCondition(scard.descon)
	e8:SetOperation(scard.desop1)
	c:RegisterEffect(e8)
	--discard spell
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(DM_LOCATION_RULES)
	e9:SetOperation(aux.chainreg)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetCode(EVENT_CHAIN_SOLVED)
	e10:SetOperation(scard.tgop1)
	c:RegisterEffect(e10)
	--register broken shield
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_TO_HAND)
	e11:SetRange(DM_LOCATION_RULES)
	e11:SetCondition(scard.regcon2)
	e11:SetOperation(scard.regop2)
	c:RegisterEffect(e11)
	--win game
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_ADJUST)
	e12:SetRange(DM_LOCATION_RULES)
	e12:SetCondition(scard.wincon)
	e12:SetOperation(scard.winop)
	c:RegisterEffect(e12)
	--can set in szone
	local e13=Effect.CreateEffect(c)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_MONSTER_SSET)
	e13:SetRange(DM_LOCATION_RULES)
	e13:SetTargetRange(LOCATIONS_ALL,0)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsCreature))
	e13:SetValue(TYPE_SPELL)
	c:RegisterEffect(e13)
	local e14=Effect.CreateEffect(c)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_CANNOT_SSET)
	e14:SetRange(DM_LOCATION_RULES)
	e14:SetTargetRange(1,0)
	e14:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	c:RegisterEffect(e14)
	--cannot trigger
	local e15=Effect.CreateEffect(c)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_CANNOT_TRIGGER)
	e15:SetRange(DM_LOCATION_RULES)
	e15:SetTargetRange(DM_LOCATION_SHIELD,0)
	e15:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	c:RegisterEffect(e15)
	--no battle damage
	local e16=Effect.CreateEffect(c)
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e16:SetRange(DM_LOCATION_RULES)
	e16:SetTargetRange(DM_LOCATION_BATTLE,0)
	e16:SetValue(1)
	c:RegisterEffect(e16)
	--set def equal to atk
	local e17=Effect.CreateEffect(c)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e17:SetRange(DM_LOCATION_RULES)
	e17:SetTargetRange(DM_LOCATION_BATTLE,0)
	e17:SetValue(scard.defval)
	c:RegisterEffect(e17)
	--destroy equal & lower def
	local e18=Effect.CreateEffect(c)
	e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e18:SetDescription(aux.Stringid(sid,2))
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e18:SetCode(EVENT_DAMAGE_STEP_END)
	e18:SetRange(DM_LOCATION_RULES)
	e18:SetOperation(scard.desop2)
	c:RegisterEffect(e18)
	--to grave redirect
	local e19=Effect.CreateEffect(c)
	e19:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e19:SetRange(DM_LOCATION_RULES)
	e19:SetTargetRange(LOCATIONS_ALL,0)
	e19:SetTarget(scard.tgtg)
	e19:SetValue(DM_LOCATION_GRAVE)
	c:RegisterEffect(e19)
	local e20=Effect.CreateEffect(c)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e20:SetCode(EVENT_LEAVE_FIELD)
	e20:SetRange(DM_LOCATION_RULES)
	e20:SetCondition(scard.tgcon)
	e20:SetOperation(scard.tgop2)
	c:RegisterEffect(e20)
	--attack first turn
	if EFFECT_BP_FIRST_TURN then
		local e21=Effect.CreateEffect(c)
		e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_PLAYER_TARGET)
		e21:SetType(EFFECT_TYPE_FIELD)
		e21:SetCode(EFFECT_BP_FIRST_TURN)
		e21:SetRange(DM_LOCATION_RULES)
		e21:SetTargetRange(1,0)
		c:RegisterEffect(e21)
	end
	--skip
	dm.RuleSkipPhase(c,EFFECT_SKIP_M2)
	--infinite hand
	dm.RuleInfiniteHand(c)
	--infinite attacks
	dm.RuleInfiniteAttack(c)
	--cannot change position
	dm.RuleCannotChangePosition(c)
	--no effect damage
	dm.RuleNoEffectDamage(c)
	--cannot summon/mset
	dm.RuleCannotSummonMSet(c)
	--cannot replay
	dm.RuleCannotReplay(c)
	--protect
	dm.RuleProtect(c)
end
scard.duel_masters_card=true
--apply
function scard.filter(c)
	return not c.duel_masters_card
end
function scard.condition(e)
	local tp=e:GetHandlerPlayer()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATIONS_ALL,1,nil,sid) then
		return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()==1
	else return Duel.GetTurnCount()==1 end
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	--apply rules for you
	local fc1=Duel.GetFieldCard(tp,DM_LOCATION_SHIELD,5)
	if fc1 then
		Duel.SendtoDeck(fc1,PLAYER_OWNER,DECK_SEQUENCE_UNEXIST,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(e:GetHandler(),tp,tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	--apply rules for opponent
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATIONS_ALL,nil,sid)
	if g:GetCount()>0 then
		local fc2=Duel.GetFieldCard(1-tp,DM_LOCATION_SHIELD,5)
		if fc2 then
			Duel.SendtoDeck(fc2,PLAYER_OWNER,DECK_SEQUENCE_UNEXIST,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(g:GetFirst(),tp,1-tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	else
		local rule=Duel.CreateToken(1-tp,sid)
		Duel.MoveToField(rule,tp,1-tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	end
	--shuffle your deck
	local hg1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg1:GetCount()>0 then
		Duel.SendtoDeck(hg1,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
	end
	--shuffle opponent's deck
	local hg2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg2:GetCount()>0 then
		Duel.SendtoDeck(hg2,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(1-tp)
	end
	--check deck size
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=40
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)~=40
	--check for non-duel masters cards
	local b3=Duel.GetMatchingGroupCount(scard.filter,tp,LOCATIONS_ALL,0,nil)>0
	local b4=Duel.GetMatchingGroupCount(scard.filter,tp,0,LOCATIONS_ALL,nil)>0
	if b1 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_DECKCOUNT) end
	if b2 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_NONDM) end
	if b4 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_NONDM) end
	if b1 and b2 or b3 and b4 then
		Duel.Win(1-tp,DM_WIN_REASON_INVALID)
		Duel.Win(tp,DM_WIN_REASON_INVALID)
		return
	elseif b1 or b3 then
		Duel.Win(1-tp,DM_WIN_REASON_INVALID)
		return
	elseif b2 or b4 then
		Duel.Win(tp,DM_WIN_REASON_INVALID)
		return
	end
	--set your life
	Duel.SetLP(tp,1)
	--set opponent's life
	Duel.SetLP(1-tp,1)
	--set your shields
	Duel.SendDecktoptoShield(tp,5)
	--set opponent's shields
	Duel.SendDecktoptoShield(1-tp,5)
	--draw your starting hand
	Duel.Draw(tp,5,REASON_RULE)
	--draw opponent's starting hand
	Duel.Draw(1-tp,5,REASON_RULE)
end
--untap
function scard.posfilter(c)
	return c:IsTapped()
end
function scard.poscon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(scard.posfilter,tp,DM_LOCATION_BATTLE+DM_LOCATION_MANA,0,1,nil)
		and Duel.GetTurnPlayer()==tp
end
function scard.posop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsTapped,tp,DM_LOCATION_BATTLE+DM_LOCATION_MANA,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
end
--charge
function scard.tmcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(Card.IsAbleToMana,tp,LOCATION_HAND,0,1,nil)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMANA)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,0,1,nil)
	if not g:IsExists(Card.IsAbleToMana,1,nil) then return end
	Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_RULE)
end
--summoning sickness
function scard.cfilter1(c,tp)
	return not c:IsCanAttackTurn() and c:IsControler(tp)
end
function scard.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter1,1,nil,tp)
end
function scard.regop1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(DM_DESC_SUMMONSICKNESS)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(e1)
		e2:SetCondition(scard.rscon)
		e2:SetOperation(scard.rsop)
		e2:SetReset(RESET_EVENT+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function scard.rscon(e)
	return e:GetLabelObject() and e:GetLabelObject():GetLabelObject()
		and e:GetLabelObject():GetLabelObject():IsCanAttackTurn()
end
function scard.rsop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
end
--chain limit
function scard.chop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(DM_EFFECT_FLAG_ATTACK_TRIGGER) and not re:IsHasCategory(DM_CATEGORY_BLOCKER) then return end
	Duel.SetChainLimit(scard.chlimit)
end
function scard.chlimit(e,rp,tp)
	return not e:IsHasCategory(DM_CATEGORY_BLOCKER)
end
--attack cost workaround
function scard.poscon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttacker():IsRelateToBattle() and Duel.GetAttacker():IsControler(tp)
end
function scard.posop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(Duel.GetAttacker(),POS_FACEUP_TAPPED)
end
--destroy 0 power
function scard.desfilter(c)
	return c:IsFaceup() and c:IsCreature() and c:GetPower()<=0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function scard.descon(e)
	return Duel.IsExistingMatchingCard(scard.desfilter,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,nil)
end
function scard.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BATTLE,0,nil)
	Duel.Destroy(g,REASON_RULE)
end
--discard spell
function scard.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsSpell() or e:GetHandler():GetFlagEffect(1)==0 then return end
	if re:IsHasProperty(DM_EFFECT_FLAG_CHARGE) then
		Duel.SendtoMana(rc,POS_FACEUP_UNTAPPED,REASON_RULE)
	else Duel.SendtoDMGrave(rc,REASON_RULE+REASON_DISCARD) end
end
--register broken shield
function scard.cfilter2(c,tp)
	return c:IsPreviousLocation(DM_LOCATION_SHIELD) and c:GetPreviousSequence()<5
		and c:IsReason(DM_REASON_BREAK) and c:IsControler(tp)
end
function scard.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter2,1,nil,tp)
end
function scard.regop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if not tc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) then Duel.Hint(HINT_MESSAGE,tp,DM_HINTMSG_NOSTRIGGER) end
		--register broken shield for Card.IsBrokenShield
		tc:RegisterFlagEffect(DM_EFFECT_BROKEN_SHIELD,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,DM_DESC_BROKEN)
		--register broken shield for Card.GetShieldBreakCount
		re:GetHandler():RegisterFlagEffect(DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
		--register broken shield for Duel.GetShieldBreakCount
		Duel.RegisterFlagEffect(re:GetHandler():GetControler(),DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
	end
end
--win game
function scard.wincon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)==0
end
function scard.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(1-tp,DM_WIN_REASON_DECKOUT)
end
--set def equal to atk
function scard.defval(e,c)
	return c:GetPower()
end
--destroy equal & lower def
function scard.desop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not a:IsOnField() or not d or not d:IsOnField() or not d:IsDefensePos()
		or Duel.GetTurnPlayer()~=tp then return end
	local ab1=a:IsHasEffect(EFFECT_INDESTRUCTIBLE) and a:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local ab2=d:IsHasEffect(EFFECT_INDESTRUCTIBLE) and d:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local g=Group.CreateGroup()
	if a:GetAttack()<d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) end
	elseif a:GetAttack()==d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) end
		if not ab2 and d:IsRelateToBattle() then g:AddCard(d) end
	end
	Duel.Destroy(g,REASON_RULE--[[+REASON_BATTLE]])
end
--to grave redirect
function scard.tgtg(e,c)
	return c:IsReason(REASON_DESTROY) or c:IsReason(REASON_BATTLE)
end
function scard.cfilter3(c,tp)
	return c:GetStackCount()>0 and c:IsControler(tp)
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter3,1,nil,tp)
end
function scard.tgop2(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		local g=ec:GetStackGroup()
		g=g:Filter(Card.IsAbleToDMGrave,nil)
		for tc in aux.Next(g) do
			Duel.SendtoDMGrave(tc,REASON_RULE)
		end
	end
end
