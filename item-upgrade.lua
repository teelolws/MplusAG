local db = {
    explorer = {
        enUS = "Explorer",
        esMX = "Expedicionario",
        ptBR = "Explorador",
        frFR = "Explorateur",
        deDE = "Forscher",
        esES = "Expedicionario",
        itIT = "Esploratore",
        ruRU = "Исследователь",
        koKR = "탐험가",
        zhTW = "探險者",
        zhCN = "探索者",
        lower = 376,
        upper = 398,
    },
    adventurer = {
        enUS = "Adventurer",
        esMX = "Aventurero",
        ptBR = "Aventureiro",
        frFR = "Aventurier",
        deDE = "Abenteurer",
        esES = "Aventurero",
        itIT = "Avventuriero",
        ruRU = "Искатель приключений",
        koKR = "모험가",
        zhTW = "冒險者",
        zhCN = "冒险者",
        lower = 389,
        upper = 411,
    },
    veteran = {
        enUS = "Veteran",
        esMX = "Veterano",
        ptBR = "Veterano",
        frFR = "Vétéran",
        deDE = "Veteran",
        esES = "Veterano",
        itIT = "Veterano",
        ruRU = "Ветеран",
        koKR = "노련가",
        zhTW = "精兵",
        zhCN = "老兵",
        lower = 402,
        upper = 424,
    },
    champion = {
        enUS = "Champion",
        esMX = "Campeón",
        ptBR = "Campeão",
        frFR = "Champion",
        deDE = "Champion",
        esES = "Campeón",
        itIT = "Campione",
        ruRU = "Защитник",
        koKR = "챔피언",
        zhTW = "勇士",
        zhCN = "勇士",
        lower = 415,
        upper = 437,
    },
    hero = {
        enUS = "Hero",
        lower = 428,
        upper = 441,
    },
}

local pattern = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
pattern = pattern:gsub("%%d", "%%s")
pattern = pattern:format("(.+)", "(%d)", "(%d)")
TooltipDataProcessor.AddTooltipPreCall(Enum.TooltipDataType.Item, function(tooltip, data)
    for k, v in pairs(data.lines) do
        if type(v) == "table" then
            local text = v.leftText
            local match, _, rank, lower, upper = text:find(pattern)
            if match then
                for _, data in pairs(db) do
                    if data[GetLocale()] and (data[GetLocale()] == rank) then 
                        if lower ~= upper then
                            v.leftText = text.." "..DISABLED_FONT_COLOR:GenerateHexColorMarkup().."("..data.lower.."-"..data.upper..")|r"
                        end
                    end
                end
            end
        end
    end
end)
