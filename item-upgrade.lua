local db = {
    ["Explorer"] = {
        lower = 376,
        upper = 398,
    },
    ["Adventurer"] = {
        lower = 389,
        upper = 411,
    },
    ["Veteran"] = {
        lower = 402,
        upper = 424,
    },
    ["Champion"] = {
        lower = 415,
        upper = 437,
    },
    ["Hero"] = {
        lower = 428,
        upper = 441,
    },
}

TooltipDataProcessor.AddTooltipPreCall(Enum.TooltipDataType.Item, function(tooltip, data)
    for k, v in pairs(data.lines) do
        if type(v) == "table" then
            local text = v.leftText
            local pattern = ITEM_UPGRADE_TOOLTIP_FORMAT_STRING
            pattern = pattern:gsub("%%d", "%%s")
            pattern = pattern:format("([%s%w]+)", "(%d)", "(%d)")
            local match, _, rank, lower, upper = text:find(pattern)
            if match then
                if db[rank] then
                    if lower ~= upper then
                        v.leftText = text.." "..DISABLED_FONT_COLOR:GenerateHexColorMarkup().."("..db[rank].lower.."-"..db[rank].upper..")|r"
                    end
                end
            end
        end
    end
end)
