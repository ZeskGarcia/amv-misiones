Config = {}
Config.NPCCoords = vector3(607.05, -3058.91, 5.1)
Config.NPCHasModel = "a_m_m_og_boss_01"
Config.VehicleSpawnCoords = vector3(607.11, -3049.87, 6.07)
Config.Missions = {
    ["mafia"] = {
        ["tittle"] = '🟢 - Mision Mafia',
        ["vehicle"] = "bf400",
        ["reward"] = vector4(1257.88, -2567.0, 42.72, 104.18),
        ["reward_vehicle"] = "burrito",
        ["box_prop"] = "prop_box_ammo03a_set2",
        ["boxes"] = {
            vector4(1264.51, -2567.6, 42.86, 100.12),
            vector4(1268.33, -2567.15, 43.1, 188.55),
            vector4(1260.29, -2559.64, 42.72, 34.13)
        }
    },
}

Config.Rewards = {
    [1] = {
        ["item"] = "weapon_pistol",
        ["unique"] = true,
        ["amount"] = math.random(5, 7)
    },
    [2] = {
        ["item"] = "weapon_assaultrifle",
        ["unique"] = true,
        ["amount"] = math.random(5, 7)
    },
    [3] = {
        ["item"] = "weapon_sniperrifle",
        ["unique"] = true,
        ["amount"] = math.random(5, 7)
    },
    [4] = {
        ["item"] = "weapon_pistol_mk2",
        ["unique"] = true,
        ["amount"] = math.random(5, 7)
    },
}

Config.Translations = {
    ["phone_notify"] = "Te acaban de enviar al movil unas coordenadas donde tendras que ir y recoger unos paquetes. Ten cuidado me ha dicho que hay varios malotes esperandote alli. ¡Ten suerte!",
    ["mission_create"] = "Ya tienes una misión iniciada"
}