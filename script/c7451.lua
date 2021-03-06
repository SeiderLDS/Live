--古代の機械熱核竜
--Ancient Gear Reactor Dragon
--Scripted by Eerie Code
function c7451.initial_effect(c)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c7451.valcheck)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c7451.regcon)
	e2:SetOperation(c7451.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c7451.aclimit)
	e3:SetCondition(c7451.actcon)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7451,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c7451.descon)
	e4:SetTarget(c7451.destg)
	e4:SetOperation(c7451.desop)
	c:RegisterEffect(e4)
end

function c7451.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSetCard(0x7) then
			flag=bit.bor(flag,0x1)
		end
		if tc:IsSetCard(0x51) then
			flag=bit.bor(flag,0x2)
		end
		tc=g:GetNext()
	end
	e:SetLabel(flag)
end

function c7451.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c7451.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabelObject():GetLabel()
	if bit.band(flag,0x1)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(7451,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
	if bit.band(flag,0x2)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(7451,1))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EXTRA_ATTACK)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e4)
	end
end

function c7451.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c7451.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function c7451.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function c7451.desfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c7451.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c7451.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7451.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c7451.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c7451.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
