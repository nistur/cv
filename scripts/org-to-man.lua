
local org_path = arg[1]
local man_path = org_path:gsub(".org",".6")

local man_file = io.open( man_path, "w+" )


local function macro(_macro, _dat)
   if _macro == "TITLE" then
      man_file:write(".TH " .. _dat:gsub(" ", "_"):upper() .. " 6\n" )
   end
end

local function heading( heading )
   if heading:len() > 1 then
      man_file:write(".SH " .. heading:upper() .. "\n" )
   end
end

local function subheading( subheading )
   man_file:write("\n.B " .. subheading .. "\n\n" )
end

local function itemise( item )
   man_file:write( "\n\\- \n" )
   local additions = item:find( "%(" )
   if additions then
      man_file:write( ".I " .. item:sub( 0, additions - 1 ) .. "\n" )
      man_file:write( item:sub( additions ) .. "\n\n" )
   else
      man_file:write( item .. "\n" )
   end
end

for line in io.lines( org_path ) do
   if line:find( " " ) == 1 then
      line = line:gsub("^ +", "" )
   else
      man_file:write("\n")
   end
   if line:find( "%#%+" ) == 1 then
      local separator = line:find("%: ")
      local _macro = line:sub(3, separator-1)
      local _dat = line:sub( separator+2 )
      macro( _macro, _dat )
   elseif line:find( "%* " ) == 1 then
      heading( line:sub(3) )
   elseif line:find( "%*%* " ) == 1 then
      subheading( line:sub(4) )
   elseif line:find( "%+ " ) == 1 then
      itemise( line:sub(3) )
   else
      man_file:write(line .. " ")
   end
end

man_file:close()

