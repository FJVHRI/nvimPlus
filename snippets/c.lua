-- Generated from c.json by scripts/convert-snippets.lua. Do not edit by hand.
-- Edit the source JSON and re-run the converter, or edit here and remove the JSON.
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then table.insert(snippets, snip) end
end

add("fun", "${1:return_type} ${2:function_name}(${3:}) {\n\t${0}\n}", "function definition")
add("var", "${1:type} ${2:var_name} = ${3:};${0}", "variable declaration")

return snippets

