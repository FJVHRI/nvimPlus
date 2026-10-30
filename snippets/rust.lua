-- Generated from rust.json by scripts/convert-snippets.lua. Do not edit by hand.
-- Edit the source JSON and re-run the converter, or edit here and remove the JSON.
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then
    table.insert(snippets, snip)
  end
end

add("macro", "macro_rules! ${1} {\n\t(${2}) => (\n\t\t${3}\n\t)\n}", "macro_rules definition")
add("pfn", "pub fn ${1:name}(${2}) ${3}{\n\t${0}\n}", "public function")
add("let", "let ${1} = ${2};${0}", "immutable variable")
add("letm", "let mut ${1} = ${2};${0}", "mutable variable")
add("st", "struct ${1} {\n\t${0}\n}", "struct definition")
add("opt", "Option<${1:T}>${0}", "Option<T> type")
add("enum", "enum ${1} {\n\t${0}\n}", "enum definition")
add("sf", 'String::from("${1}");${0}', "String::from")
add("if", "if ${1} {\n\t${0}\n}", "if statement")
add("rc", "Rc::new(${1})${0}", "Rc::new()")
add("vec", "Vec::new()${0}", "Vec::new()")
add("fn", "fn ${1:name}(${2}) ${3}{\n\t${0}\n}", "function definition")
add("box", "Box::new(${1})${0}", "Box::new()")
add("res", "Result<${1:T}, ${2:E}>${0}", "Result<T, E> type")
add("dbg", "dbg!(${1})${0}", "dbg! macro")
add("for", "for ${1} in ${2} {\n\t${0}\n}", "for loop")
add("der", "#[derive(${1:Debug})]${0}", "derive attribute")
add("pri", 'print!("${1}");${0}', "print! macro")
add("match", "match ${1} {\n\t${2:_} => ${3:todo!()},\n}", "match expression")
add("while", "while ${1} {\n\t${0}\n}", "while loop")
add("impl", "impl ${1} {\n\t${0}\n}", "impl block")
add("pln", 'println!("${1}");${0}', "println! macro")

add("fnr", "fn ${1:name}(${2}) -> ${3:ReturnType} {\n\t${0}\n}", "function with return type")
add("pfnr", "pub fn ${1:name}(${2}) -> ${3:ReturnType} {\n\t${0}\n}", "public function with return type")
add("afn", "async fn ${1:name}(${2}) -> ${3:ReturnType} {\n\t${0}\n}", "async function")
add("closure", "|${1:params}| ${2:{ ${0} }}", "closure")
add("lett", "let ${1:name}: ${2:Type} = ${3:value};", "variable with type")
add("letmt", "let mut ${1:name}: ${2:Type} = ${3:value};", "mutable variable with type")
add("const", "const ${1:NAME}: ${2:Type} = ${3:value};", "const")
add("static", "static ${1:NAME}: ${2:Type} = ${3:value};", "static")
add("type", "type ${1:Name} = ${2:Type};", "type alias")
add("ifelse", "if ${1} {\n\t${2}\n} else {\n\t${0}\n}", "if-else")
add("elif", "else if ${1} {\n\t${0}\n}", "else if")
add("iflet", "if let ${1:Some(${2:x})} = ${3:expr} {\n\t${0}\n}", "if let ... =")
add("ifletelse", "if let ${1:Some(${2:x})} = ${3:expr} {\n\t${4}\n} else {\n\t${0}\n}", "if let ... else")
add("whilelet", "while let ${1:Some(${2:x})} = ${3:expr} {\n\t${0}\n}", "while let ... =")
add("loop", "loop {\n\t${0}\n}", "loop")
add("matchopt", "match ${1:opt} {\n\tSome(${2:x}) => ${3},\n\tNone => ${0},\n}", "match Option<T>")
add("matchres", "match ${1:res} {\n\tOk(${2:x}) => ${3},\n\tErr(${4:e}) => ${0},\n}", "match Result<T,E>")
add("pst", "pub struct ${1} {\n\t${0}\n}", "pub struct")
add("stt", "struct ${1:Name}(${2:Type});", "tuple struct")
add("penum", "pub enum ${1} {\n\t${0}\n}", "pub enum")
add("implfor", "impl ${1:Trait} for ${2:Type} {\n\t${0}\n}", "impl Trait for Type")
add("trait", "trait ${1:Name} {\n\t${0}\n}", "trait definition")
add("ptrait", "pub trait ${1:Name} {\n\t${0}\n}", "pub trait")
add("derfull", "#[derive(Debug, Clone, PartialEq, Eq)]", "#[derive(Debug, Clone, PartialEq)]")
add("vecm", "vec![${1}]", "vec![]")
add("arc", "Arc::new(${1})", "Arc::new()")
add("mutex", "Mutex::new(${1})", "Mutex::new()")
add("rwlock", "RwLock::new(${1})", "RwLock::new()")
add("cell", "Cell::new(${1})", "Cell::new()")
add("refcell", "RefCell::new(${1})", "RefCell::new()")
add("hashmap", "HashMap::new()", "HashMap::new()")
add("hashset", "HashSet::new()", "HashSet::new()")
add("ref", "&${1:expr}", "& reference")
add("refm", "&mut ${1:expr}", "&mut reference")
add("eprintln", 'eprintln!("${1}");', "eprintln! macro")
add("todo", "todo!()", "todo!()")
add("unimpl", "unimplemented!()", "unimplemented!()")
add("unreach", "unreachable!()", "unreachable!()")
add("panic", 'panic!("${1:message}");', "panic!()")
add("assert", "assert!(${1:condition});", "assert!")
add("asserteq", "assert_eq!(${1:left}, ${2:right});", "assert_eq!")
add("assertne", "assert_ne!(${1:left}, ${2:right});", "assert_ne!")
add("mod", "mod ${1:name} {\n\t${0}\n}", "module")
add("pmod", "pub mod ${1:name} {\n\t${0}\n}", "pub mod")
add("use", "use ${1:std::collections::HashMap};", "use ...")
add("useas", "use ${1:std::collections::HashMap} as ${2:HMap};", "use ... as ...")
add("test", "#[test]\nfn ${1:test_name}() {\n\t${0}\n}", "#[test] fn")
add(
  "modtest",
  "#[cfg(test)]\nmod tests {\n\tuse super::*;\n\n\t#[test]\n\tfn ${1:test_name}() {\n\t\t${0}\n\t}\n}",
  "test module"
)
add("shouldpanic", "#[test]\n#[should_panic]\nfn ${1:test_name}() {\n\t${0}\n}", "#[should_panic]")
add("main", "fn main() {\n\t${0}\n}", "fn main()")
add("mainres", "fn main() -> Result<(), Box<dyn std::error::Error>> {\n\t${0}\n\tOk(())\n}", "fn main() -> Result<()>")
add(
  "lifetime",
  "fn ${1:name}<'${2:a}>(${3:x} &'$2 ${4:Type}) -> &'$2 ${5:ReturnType} {\n\t${0}\n}",
  "function with lifetime"
)
add("clone", ".clone()", ".clone()")
add("await", ".await", ".await")
add("unwrap", ".unwrap()", ".unwrap()")
add("expect", '.expect("${1:message}")', ".expect()")
add("andthen", ".and_then(|${1:x}| ${0})", ".and_then()")
add("map", ".map(|${1:x}| ${0})", ".map()")

return snippets
