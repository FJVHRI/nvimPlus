-- Lua snippets (hand-maintained; not converted from JSON).
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then table.insert(snippets, snip) end
end

add("fn", "local function ${1:name}(${2:args})\n\t$0\nend", "local function")
add("req", "local ${1|M,m} = require(\"${2:module}\")$0", "require module")
add("for", "for ${1:i} = ${2:1}, ${3:10} do\n\t$0\nend", "numeric for loop")
add("forp", "for ${1:k}, ${2:v} in pairs(${3:t}) do\n\t$0\nend", "pairs iteration")
add("fori", "for ${1:i}, ${2:v} in ipairs(${3:t}) do\n\t$0\nend", "ipairs iteration")
add("ifel", "if ${1:cond} then\n\t${2}\nelse\n\t${3}\nend", "if/else")
add("loc", "local ${1:name} = ${2:value}", "local variable")

return snippets
