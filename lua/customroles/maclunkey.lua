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
    resource.AddFile("materials/vgui/ttt/icon_mac.vmt")
    resource.AddFile("materials/vgui/ttt/sprite_mac.vmt")
    resource.AddSingleFile("materials/vgui/ttt/sprite_mac_noz.vmt")
    resource.AddSingleFile("materials/vgui/ttt/score_mac.png")
    resource.AddSingleFile("materials/vgui/ttt/tab_mac.png")
end