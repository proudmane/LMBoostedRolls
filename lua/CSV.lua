local Main = LMBoostedRolls
local CSV = {}
Main.CSV = CSV

-- CSV Module
-- http://help.interfaceware.com/kb/parsing-csv-files

local function parseCsvLine (line,sep) 
    local res = {}
    local pos = 1
    sep = sep or ','
    while true do 
        local c = string.sub(line,pos,pos)
        if (c == "") then break end
        local posn = pos 
        local ctest = string.sub(line,pos,pos)
        while ctest == ' ' do
            -- handle space(s) at the start of the line (with quoted values)
            posn = posn + 1
            ctest = string.sub(line,posn,posn) 
            if ctest == '"' then
                pos = posn
                c = ctest
            end
        end
        if (c == '"') then
            -- quoted value (ignore separator within)
            local txt = ""
            repeat
                local startp,endp = string.find(line,'^%b""',pos)
                txt = txt..string.sub(line,startp+1,endp-1)
                pos = endp + 1
                c = string.sub(line,pos,pos) 
                if (c == '"') then 
                txt = txt..'"' 
                -- check first char AFTER quoted string, if it is another
                -- quoted string without separator, then append it
                -- this is the way to "escape" the quote char in a quote. example:
                --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
                elseif c == ' ' then
                -- handle space(s) before the delimiter (with quoted values)
                while c == ' ' do
                    pos = pos + 1
                    c = string.sub(line,pos,pos) 
                end
                end
            until (c ~= '"')
            table.insert(res,txt)
            if not (c == sep or c == "") then 
                error("ERROR: Invalid CSV field - near character "..pos.." in this line of the CSV file: \n"..line, 3)
            end
            pos = pos + 1
            posn = pos 
            ctest = string.sub(line,pos,pos)
            while ctest == ' ' do
                -- handle space(s) after the delimiter (with quoted values)
                posn = posn + 1
                ctest = string.sub(line,posn,posn) 
                if ctest == '"' then
                pos = posn
                c = ctest
                end
            end
        else	
            -- no quotes used, just look for the first separator
            local startp,endp = string.find(line,sep,pos)
            if (startp) then 
                table.insert(res,string.sub(line,pos,startp-1))
                pos = endp + 1
            else
                -- no separator found -> use rest of string and terminate
                table.insert(res,string.sub(line,pos))
                break
            end 
        end
    end
    return res
end

------------------------------------
---- Module Interface functions ----
------------------------------------

function CSV:parseCsv(Data, Separator)
    -- handle '\r\n\' as line separator
    Data = Data:gsub('\r\n','\n')
    -- handle '\r' (bad form) as line separator  
    Data = Data:gsub('\r','\n')
    local Result={}

    for Line in Data:gmatch("([^\n]+)") do
        local ParsedLine = parseCsvLine(Line, Separator)
        table.insert(Result, ParsedLine)
    end

    return Result
end

function CSV:Test(arg)
    local result = table.tostring(
      arg
        -- CSV:parseCsv(
        --     "Item,ItemId,From,Name,Class,Spec,Note,Plus,Date\n\"Amulet of Unfettered Magics\",34204,\"Eredar Twins\",Baradule,Warlock,Destruction,+legs,2,\"2022-08-12 14:22:39\"\n\"Amulet of Unfettered Magics\",34204,\"Eredar Twins\",Narrnarr,Warlock,Affliction,\"+ leggs\",6,\"2022-08-13 17:54:19\"\n\"Amulet of Unfettered Magics\",34204,\"Eredar Twins\",Wharman,Shaman,Elemental,neck,5,\"2022-08-13 09:37:04\"\n\"Archon\'s Gavel\",34199,\"Eredar Twins\",Arriee,Paladin,Holy,\"+ mace\",5,\"2022-08-11 23:28:53\"\n\"Band of Ruinous Delight\",34189,\"Eredar Twins\",Faustino,Warrior,Fury,\"ring +\",6,\"2022-08-11 23:17:41\"\n\"Blackened Naaru Sliver\",34427,M\'uru,Fàtal,Shaman,Enhancement,\"plus pants\",4,\"2022-08-12 20:26:02\"\n\"Blackened Naaru Sliver\",34427,M\'uru,Redevelop,Hunter,Survival,\"+ on shiv\",2,\"2022-08-13 22:12:04\"\n\"Blackened Naaru Sliver\",34427,M\'uru,Warsawt,Hunter,\"Beast Mastery\",\"Plus legs\",7,\"2022-08-13 12:39:55\"\n\"Book of Highborne Hymns\",34206,\"Eredar Twins\",Bentlie,Druid,Restoration,\"WK 4 Book of Highbor\",3,\"2022-08-11 23:22:15\"\n\"Book of Highborne Hymns\",34206,\"Eredar Twins\",Cantaperme,Shaman,Restoration,\"+7 book\",4,\"2022-08-14 11:33:24\"\n\"Book of Highborne Hymns\",34206,\"Eredar Twins\",Zohsham,Shaman,Restoration,book,3,\"2022-08-14 13:21:00\"\n\"Collar of the Pit Lord\",34178,Brutallus,Wexford,Paladin,Protection,collar,2,\"2022-08-11 23:20:00\"\n\"Collar of the Pit Lord\",34178,Brutallus,Wulinur,Druid,Feral,Legs+,7,\"2022-08-13 18:43:04\"\n\"Equilibrium Epaulets\",34208,\"Eredar Twins\",Cantaperme,Shaman,Restoration,\"+7 book\",4,\"2022-08-14 11:33:24\"\n\"Equilibrium Epaulets\",34208,\"Eredar Twins\",Zohsham,Shaman,Restoration,book,3,\"2022-08-14 13:21:00\"\n\"Golden Bow of Quel\'Thalas\",34196,\"Eredar Twins\",Covfeefee,Rogue,Swords,\"+ leggings\",3,\"2022-08-13 08:26:20\"\n\"Harness of Carnal Instinct\",34211,M\'uru,Chadokun,Paladin,Retribution,+Legs,7,\"2022-08-12 14:26:11\"\n\"Harness of Carnal Instinct\",34211,M\'uru,Deadlysly,Rogue,Swords,+Legs,7,\"2022-08-11 23:31:51\"\n\"Heart of the Pit\",34179,Brutallus,Kastana,Mage,Arcane,\"Leggings +\",7,\"2022-08-15 18:40:32\"\n\"Leggings of Calamity\",34181,Brutallus,Baradule,Warlock,Destruction,+legs,2,\"2022-08-12 14:22:39\"\n\"Leggings of Calamity\",34181,Brutallus,Kastana,Mage,Arcane,\"Leggings +\",7,\"2022-08-15 18:40:32\"\n\"Leggings of Calamity\",34181,Brutallus,Macroween,Mage,Arcane,Pants,7,\"2022-08-12 07:02:55\"\n\"Leggings of Calamity\",34181,Brutallus,Narrnarr,Warlock,Affliction,\"+ leggs\",6,\"2022-08-13 17:54:19\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Chadokun,Paladin,Retribution,+Legs,7,\"2022-08-12 14:26:11\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Covfeefee,Rogue,Swords,\"+ leggings\",3,\"2022-08-13 08:26:20\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Deadlysly,Rogue,Swords,+Legs,7,\"2022-08-11 23:31:51\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Fàtal,Shaman,Enhancement,\"plus pants\",4,\"2022-08-12 20:26:02\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Warsawt,Hunter,\"Beast Mastery\",\"Plus legs\",7,\"2022-08-13 12:39:55\"\n\"Leggings of the Immortal Night\",34188,Felmyst,Wulinur,Druid,Feral,Legs+,7,\"2022-08-13 18:43:04\"\n\"Legplates of the Holy Juggernaut\",34167,Kalecgos,Arriee,Paladin,Holy,\"+ mace\",5,\"2022-08-11 23:28:53\"\n\"Pantaloons of Calming Strife\",34170,Kalecgos,Rheeos,Priest,Shadow,\"+ pants\",7,\"2022-08-14 21:05:57\"\n\"Pauldrons of Perseverance\",34192,\"Eredar Twins\",Adith,Warrior,Protection,\"+ shoulders\",2,\"2022-08-11 23:17:29\"\n\"Pauldrons of Perseverance\",34192,\"Eredar Twins\",Faustino,Warrior,Fury,\"ring +\",6,\"2022-08-11 23:17:41\"\n\"Reign of Misery\",34176,Brutallus,Gajijjuju,Druid,Balance,\"+ mace\",1,\"2022-08-11 23:36:28\"\n\"Ring of Hardened Resolve\",34213,M\'uru,Wexford,Paladin,Protection,collar,2,\"2022-08-11 23:20:00\"\n\"Robes of Faltered Light\",34233,M\'uru,Lenord,Priest,Holy,\"+ shoulders\",6,\"2022-08-13 17:06:35\"\n\"Robes of Faltered Light\",34233,M\'uru,Obihunch,Mage,Arcane,,0,\"2022-08-11 23:18:02\"\n\"Shawl of Wonderment\",34202,\"Eredar Twins\",Lenord,Priest,Holy,\"+ shoulders\",6,\"2022-08-13 17:06:35\"\n\"Shifting Naaru Sliver\",34429,M\'uru,Macroween,Mage,Arcane,Pants,7,\"2022-08-12 07:02:55\"\n\"Shifting Naaru Sliver\",34429,M\'uru,Obihunch,Mage,Arcane,,0,\"2022-08-11 23:18:02\"\n\"Shifting Naaru Sliver\",34429,M\'uru,Rheeos,Priest,Shadow,\"+ pants\",7,\"2022-08-14 21:05:57\"\n\"Shifting Naaru Sliver\",34429,M\'uru,Wharman,Shaman,Elemental,neck,5,\"2022-08-13 09:37:04\"\n\"Shiv of Exsanguination\",34197,\"Eredar Twins\",Redevelop,Hunter,Survival,\"+ on shiv\",2,\"2022-08-13 22:12:04\"\nSunflare,34336,Kil\'jaeden,Gajijjuju,Druid,Balance,\"+ mace\",1,\"2022-08-11 23:36:28\"\n\"Sunglow Vest\",34212,M\'uru,Bentlie,Druid,Restoration,\"WK 4 Book of Highbor\",3,\"2022-08-11 23:22:15\"\n\"Warharness of Reckless Fury\",34215,M\'uru,Adith,Warrior,Protection,\"+ shoulders\",2,\"2022-08-11 23:17:29\""
        -- )
    )
    return result
end

function table.val_to_str ( v )
    if "string" == type( v ) then
      v = string.gsub( v, "\n", "\\n" )
      if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
        return "'" .. v .. "'"
      end
      return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
    else
      return "table" == type( v ) and table.tostring( v ) or
        tostring( v )
    end
  end
  
  function table.key_to_str ( k )
    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
      return k
    else
      return "[" .. table.val_to_str( k ) .. "]"
    end
  end
  
  function table.tostring( tbl )
    local result, done = {}, {}
    for k, v in ipairs( tbl ) do
      table.insert( result, table.val_to_str( v ) )
      done[ k ] = true
    end
    for k, v in pairs( tbl ) do
      if not done[ k ] then
        table.insert( result,
          table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
      end
    end
    return "{" .. table.concat( result, "," ) .. "}"
  end