palpatine_refraction = class({})
LinkLuaModifier( "modifier_palpatine_refraction", "abilities/palpatine_refraction.lua",LUA_MODIFIER_MOTION_NONE )

function palpatine_refraction:OnSpellStart()
    if IsServer() then 
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_palpatine_refraction", { duration = self:GetSpecialValueFor("duration") } )
        EmitSoundOn( "Hero_TemplarAssassin.Refraction", self:GetCaster() )
        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end

modifier_palpatine_refraction = class({})

function modifier_palpatine_refraction:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin())
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetCaster():GetOrigin(), true );
        ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        self.instances = self:GetAbility():GetSpecialValueFor("instances")

        if self:GetCaster():HasTalent("special_bonus_unique_palpatine_5") then 
           self.instances = self.instances + (self:GetCaster():FindTalentValue("special_bonus_unique_palpatine_5") or 0)
        end

        self:SetStackCount(self.instances)
    end
end

function modifier_palpatine_refraction:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_palpatine_refraction:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_palpatine_refraction:StatusEffectPriority()
    return 1000
end

function modifier_palpatine_refraction:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_palpatine_refraction:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_palpatine_refraction:GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_outgoing_damage")
end

function modifier_palpatine_refraction:OnTakeDamage(params)
    if IsServer() then 
        if params.unit == self:GetParent() then
            self:DecrementStackCount()

            EmitSoundOn("Hero_TemplarAssassin.Refraction.Damage", self:GetParent())
            EmitSoundOn("Hero_TemplarAssassin.Refraction.Absorb", self:GetParent())

            if self:GetStackCount() == 0 then self:Destroy() end
        end 
	end
end

function modifier_palpatine_refraction:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_palpatine_refraction:GetAbsoluteNoDamageMagical() return 1 end
function modifier_palpatine_refraction:GetAbsoluteNoDamagePhysical() return 1 end
