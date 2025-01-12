AddCSLuaFile()
local classname = "ttt_maclunkey_role_weapon"
local ShootSound = Sound("weapons/maclunkey_shoot.wav")
local DrawSound = Sound("weapons/maclunkey_draw.wav")

if CLIENT then
    SWEP.PrintName = "Maclunkey Gun"
    SWEP.Slot = 8
    SWEP.Icon = "VGUI/ttt/ttt_maclunkey_role_weapon.png"
    SWEP.ViewModelFOV = 75

    SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "While in your inventory, you cannot deal damage. \nWhile held, you take double damage. \n\nShoots a laser that kills in one shot."
    }
end

SWEP.Author = "Faaafv"
SWEP.Instructions = " "
SWEP.Category = WEAPON_CATEGORY_ROLE
SWEP.IconLetter = "w"
SWEP.UseHands = true
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawCrosshair = true
SWEP.WeaponDeploySpeed = 0.5
SWEP.ViewModel = "models/weapons/maclunkey/c_maclunkey.mdl"
SWEP.WorldModel = "models/weapons/maclunkey/w_maclunkey.mdl"
SWEP.ViewModelFlip = false
SWEP.Weight = 1
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.AutoSpawnable = false
SWEP.Primary.Recoil = .9
SWEP.Primary.Damage = 1000
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 2.0
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Tracer = "effect_sw_laser_red"
SWEP.Kind = WEAPON_ROLE
SWEP.AllowDrop = false
SWEP.NoSights = true

function SWEP:Initialize()
    self:SetDeploySpeed(self.WeaponDeploySpeed)
end

function SWEP:Deploy()
    if SERVER and self:GetOwner():Alive() and not self:GetOwner():IsSpec() then
        -- Plays the sound twice... so it's louder
        for i = 1, 2 do
            self:GetOwner():EmitSound(DrawSound, 85, 100, 1, CHAN_AUTO)
        end
    end

    self.Primary.Cone = self.HipCone

    return true
end

function SWEP:Holster()
    return true
end

function SWEP:OnDrop()
    if SERVER then
        self:Remove()
    end
end

function SWEP:ShouldDropOnDie()
    return false
end

function SWEP:PrimaryAttack()
    if (not self:CanPrimaryAttack()) then return end
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:Shoot()
    self:TakePrimaryAmmo(1)

    timer.Simple(0.1, function()
        if SERVER then
            self:Remove()
        end
    end)
end

function SWEP:Shoot()
    local cone = self.Primary.Cone
    local bullet = {}
    bullet.Num = 1
    bullet.Src = self:GetOwner():GetShootPos()
    bullet.Dir = self:GetOwner():GetAimVector()
    bullet.Spread = Vector(cone, cone, 0)
    bullet.Tracer = 1
    bullet.Force = 2
    bullet.Damage = self.Primary.Damage
    bullet.TracerName = self.Primary.Tracer
    bullet.Callback = maclunkey_bullet
    self:GetOwner():FireBullets(bullet)
    self:GetOwner():EmitSound(ShootSound, 75, 100, 1, CHAN_AUTO)
end

hook.Add("EntityTakeDamage", "MaclunkeyAlteredDamage", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if attacker and attacker:IsPlayer() and attacker:HasWeapon(classname) and attacker:GetActiveWeapon():GetClass() ~= classname then
        -- If someone is holding the maclunkey gun but not using it, negate the damage they deal
        return true
    elseif target and target:IsPlayer() and target:HasWeapon(classname) and (dmginfo:GetDamageType() == DMG_GENERIC or dmginfo:GetDamageType() == DMG_CRUSH or dmginfo:GetDamageType() == DMG_BURN or dmginfo:GetDamageType() == DMG_FALL or dmginfo:GetDamageType() == DMG_BLAST) then
        -- If someone is holding the maclunkey gun, they are immune to the same types of damage the jester is
        return true
    end
end)