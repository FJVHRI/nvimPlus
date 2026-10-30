-- Generated from ts.json by scripts/convert-snippets.lua. Do not edit by hand.
-- Edit the source JSON and re-run the converter, or edit here and remove the JSON.
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then table.insert(snippets, snip) end
end

add("type", "type $1 = {\n  $2: $3;\n};", "TS 类型别名")
add("logw", "console.warn($1);$0", "console.warn 警告")
add("con", "const $1 = $2;", "const 声明")
add("logt", "console.table($1);$0", "console.table 表格打印")
add("let", "let $1 = $2;", "let 声明")
add("arr", "const $1 = ($2) => {\n  $3\n};", "箭头函数")
add("each", "$1.forEach(($2) => {\n  $3\n});", "数组 forEach")
add("arrt", "const $1 = ($2: $3): $4 => {\n  $5\n};", "带参数/返回值类型的箭头函数")
add("fn", "function $1($2) {\n  $3\n}", "普通函数")
add("imps", "import * as $1 from '$2';", "命名空间导入")
add("logv", "console.log('$1:', $1);$0", "带变量名的 console.log 打印")
add("exp", "export default $1;", "默认导出")
add("imp", "import $1 from '$2';", "默认导入")
add("if", "if ($1) {\n  $2\n}", "if 语句")
add("fnt", "function $1($2: $3): $4 {\n  $5\n}", "带类型的函数")
add("for", "for (let $1 = 0; $1 < $2; $1++) {\n  $3\n}", "for 循环")
add("try", "try {\n  $1\n} catch (e) {\n  console.error(e);\n}", "try/catch")
add("class", "class $1 {\n  constructor($2) {\n    $3\n  }\n}", "TS 类")
add("afn", "const $1 = async ($2) => {\n  $3\n};", "异步箭头函数")
add("logi", "console.info($1);$0", "console.info 信息")
add("log", "console.log($1);$0", "console.log 输出")
add("cl", "console.log($1);$0", "console.log 输出")
add("clg", "console.log($1);$0", "console.log 输出")
add("iface", "interface $1 {\n  $2: $3;\n}", "TS 接口")
add("loge", "console.error($1);$0", "console.error 错误输出")
add("cont", "const $1: $2 = $3;", "带类型的 const")

return snippets

