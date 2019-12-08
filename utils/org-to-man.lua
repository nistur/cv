--[[
org-to-man

A simple script which parses an org-mode file and creates a standard Unix
troff formatted man page.

This is not intended to be general purpose, but instead is tailored towards
the specific and rather silly goal of exporting my CV.
]]--
local org_path = arg[1]
local man_path = arg[2] or org_path:gsub(".org",".6")

local man_file = io.open( man_path, "w+" )

-- Standard org-mode macros
local macros = {}
-- Custom macros for this exporter
local man_macros = {}


--[[
process

Process the text to replace any instances of macros etc

text: The text string to process
]]--
function process( text )

   --[[
      _process

      Workhorse function for macro processing. Will call itself
      recursively

      text: The text string to process
      start_pattern: The start of the macro symbol
      end_pattern: The end of the macro symbol
      lookup: The lookup table to use for macro replacements
   ]]--
   local function _process( text, start_pattern, end_pattern, lookup )
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

   -- I'm swapping these around intentionally, so that I can have better control
   -- over the substitution. Standard macros get ignored (and replaced with empty
   -- string later) unless they are specified with #+MAN_MACRO as well. 
   text = _process( text, "{{{", "}}}", man_macros )
   text = _process( text, "{_", "_}", macros )
   return text
end

--[[
option

Handle org-mode #+OPTIONS

opt: The option
dat: The data provided to the option
]]--
local function option(opt, dat)
   if opt == "TITLE" then
      -- Use the title for the man-page title
      man_file:write(".TH " .. dat:gsub(" ", "_"):upper() .. " 6\n" )
   elseif opt == "INCLUDE" then
      -- should we check that this has not already been loaded to stop cycling includes?
      parse( dat )
   elseif opt == "MACRO" or opt == "MAN_MACRO" then
      local endname = dat:find( " " )
      local name = dat:sub(0, endname-1 )
      -- because macros can include other macros, we need to process them
      dat = process( dat:sub( endname ):gsub("^ +", "" ) )

      -- store the macros in lookup tables to be used later
      if opt == "MACRO" then
	 macros[name] = dat
      else
	 man_macros[name] = dat
      end
   end
end

--[[
heading

Handle org-mode top level headings

heading: The title of the heading
]]--
local function heading( heading )
   if heading:len() > 1 then
      man_file:write(".SH " .. heading:upper() .. "\n" )
   end
end

--[[
subheading

Handle org-mode second level headings

subheading: The title of the subheading
]]--
local function subheading( subheading )
   man_file:write("\n.B " .. subheading .. "\n\n" )
end

--[[
itemise

Handle org-mode lists

item: The item to list
]]--
local function itemise( item )
   -- This is a bit hacky because of how I've used lists as almost sub-sub-headings
   -- in the CV
   man_file:write( "\n\\- \n" )
   local additions = item:find( "%(" )
   if additions then
      man_file:write( ".I " .. item:sub( 0, additions - 1 ) .. "\n" )
      man_file:write( item:sub( additions ) .. "\n\n" )
   else
      man_file:write( item .. "\n" )
   end
end

--[[
parse

Parse a file into the man-file output

path: The path of the file to parse
]]--
function parse( path )
   for line in io.lines( path ) do
      if line:find( "# " ) == 1 then
      -- ignore commentsn
      else
	 -- replace all macros required
	 line = process( line )
	 if line:find( "%#%+" ) == 1 then
	    -- org-mode #+OPTION
	    local separator = line:find("%: ")
	    local opt = line:sub(3, separator-1)
	    local dat = line:sub( separator+2 )
	    option( opt, dat )
	 else
	    -- normal line of some description
	    if line:find( " " ) == 1 then
	       -- strip leading spaces, this is from the paragraphing
	       -- in org-mode, but breaks troff formatting. Leaving them
	       -- on a new line with no leading spaces fixes it
	       line = line:gsub("^ +", "" )
	    else
	       -- if it's not got a leading space, we need to ensure that there's at
	       -- least one more newline, so that troff will paragraph properly
	       man_file:write("\n")
	    end
	    
	    if line:find( "%* " ) == 1 then
	       heading( line:sub(3) )
	    elseif line:find( "%*%* " ) == 1 then
	       subheading( line:sub(4) )
	    elseif line:find( "%+ " ) == 1 then
	       itemise( line:sub(3) )
	    else
	       -- Normal line, however, just replace any un-processed macros with an
	       -- empty string
	       man_file:write(line:gsub("{{{.-}}}", "") .. " ")
	    end
	 end
      end
   end
end

parse( org_path )
man_file:close()

