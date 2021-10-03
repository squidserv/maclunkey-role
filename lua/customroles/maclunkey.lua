local ROLE = {}
ROLE.nameraw = "maclunkey"
ROLE.name = "Maclunkey"
ROLE.nameplural = "Maclunkies"
ROLE.nameext = "a Maclunkey"
ROLE.nameshort = "mak"
ROLE.desc = [[You are {role}! {comrades}
You're immune to environmental damage and cannot damage others
...until you shoot your "Maclunkey Gun"!

Pretend to be a jester, then surprise everyone!]]
ROLE.team = ROLE_TEAM_TRAITOR

ROLE.shop = {"item_armor", "item_radar", "item_disg"}

ROLE.loadout = {"ttt_maclunkey_role_weapon"}

ROLE.convars = {}
RegisterRole(ROLE)

if SERVER then
    -- Prints a message to all jesters at the start of a round, telling them there is a maclunkey
    hook.Add("TTTBeginRound", "MaclunkeyAlertMessage", function()
        timer.Simple(1, function()
            local isMaclunkey = false

            for i, ply in ipairs(player.GetAll()) do
                if ply:IsMaclunkey() then
                    isMaclunkey = true
                    break
                end
            end

            if isMaclunkey then
                for i, ply in ipairs(player.GetAll()) do
                    if ply:IsJesterTeam() then
                        ply:PrintMessage(HUD_PRINTCENTER, "There is " .. ROLE_STRINGS_EXT[ROLE_MACLUNKEY])
                    end
                end
            end
        end)
    end)
end
