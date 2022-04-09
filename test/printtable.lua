function printtable(t, level)
    level = level or 0

    print(string.rep("  ", level) .. "{")

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(string.rep("  ", level) .. '"' .. k .. '":')
            printtable(v, level + 1)
        else
            print(string.rep("  ", level) .. '"' .. k .. '": ' .. v)
        end
    end

    print(string.rep("  ", level) .. "}")
end

return printtable