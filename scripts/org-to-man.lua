
local org_path = arg[1]
local man_path = org_path:gsub(".org",".6")

local man_file = io.open( man_path, "w+" )

local macros = {}
local man_macros = {}

function _process( text, start_pattern, end_pattern, lookup )
   local start_match = text:find(start_pattern)
   local start_len = start_pattern:len()
   while start_match do
      local end_match = text:find(end_pattern, start_match)

      if end_match then
	 local name = text:sub(start_match + start_len, end_match - 1)
	 if lookup[ name ] then
	    text = text:gsub(start_pattern .. name .. end_pattern, lookup[name] )
	    start_match = text:find(start_pattern, start_match)
	    text = process( text )
	 else
	    start_match = text:find(start_pattern, end_match)
	 end
      else
	 start_match = nil
      end
   end
   
   return text
end

function process( text )
   text = _process( text, "{{{", "}}}", man_macros )
   text = _process( text, "{_", "_}", macros )
   return text
end

local function option(opt, dat)
   if opt == "TITLE" then
      man_file:write(".TH " .. dat:gsub(" ", "_"):upper() .. " 6\n" )
   elseif opt == "INCLUDE" then
      parse( dat )
   elseif opt == "MACRO" or opt == "MAN_MACRO" then
      local endname = dat:find( " " )
      local name = dat:sub(0, endname-1 )
      dat = process( dat:sub( endname ):gsub("^ +", "" ) )

      if opt == "MACRO" then
	 macros[name] = dat
      else
	 man_macros[name] = dat
      end
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

function parse( path )
   for line in io.lines( path ) do
      if line:find( "# " ) == 1 then
      else
	 line = process( line )
	 if line:find( "%#%+" ) == 1 then
	    local separator = line:find("%: ")
	    local opt = line:sub(3, separator-1)
	    local dat = line:sub( separator+2 )
	    option( opt, dat )
	 else
	    
	    if line:find( " " ) == 1 then
	       line = line:gsub("^ +", "" )
	    else
	       man_file:write("\n")
	    end
	    
	    if line:find( "%* " ) == 1 then
	       heading( line:sub(3) )
	    elseif line:find( "%*%* " ) == 1 then
	       subheading( line:sub(4) )
	    elseif line:find( "%+ " ) == 1 then
	       itemise( line:sub(3) )
	    else
	       man_file:write(line:gsub("{{{.-}}}", "") .. " ")
	    end
	 end
      end
   end
end

parse( org_path )
man_file:close()

