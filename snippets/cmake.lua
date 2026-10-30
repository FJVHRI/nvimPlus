-- Generated from cmake.json by scripts/convert-snippets.lua. Do not edit by hand.
-- Edit the source JSON and re-run the converter, or edit here and remove the JSON.
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then table.insert(snippets, snip) end
end

add("find", "find_package(${1:library} ${0:REQUIRED})", "Find and load settings for an external project")
add("test", "add_test(${1:ATestName} ${0:testCommand --options})", "Add a test to the project with the specified name and command")
add("props", "set_target_properties(${1:target}\n\t${2:properties} ${3:compile_flags}\n\t${0:\"-O3 -Wall -pedantic\"}\n)", "Set properties on a target")
add("glob", "file(GLOB ${1:srcs} *.${0:cpp})", "Glob files matching a pattern into a variable")
add("set", "set(${1:var} ${0:val})", "Set a CMake variable to a given value")
add("proj", "project(${0:Name})", "Set the CMake project name")
add("subdir", "add_subdirectory(${0:src})", "Add a subdirectory to the build")
add("dep", "add_dependencies(${1:target}\n\t${0:dep}\n)", "Add a dependency between top-level targets")
add("Ext_git", "include(ExternalProject)\nExternalProject_Add(${1:googletest}\n\tGIT_REPOSITORY    ${2:https://github.com/google/googletest.git}\n\tGIT_TAG           ${3:master}\n\tSOURCE_DIR        \"${4:${CMAKE_BINARY_DIR}/googletest-src}\"\n\tBINARY_DIR        \"${0:${CMAKE_BINARY_DIR}/googletest-build}\"\n\tCONFIGURE_COMMAND \"\"\n\tBUILD_COMMAND     \"\"\n\tINSTALL_COMMAND   \"\"\n\tTEST_COMMAND      \"\"\n)", "Add an external project using a Git repository (example: googletest)")
add("min", "cmake_minimum_required(VERSION ${0:2.8.2})", "Set the minimum required CMake version")
add("bin", "add_executable(${1:bin})", "Add an executable target to the build")
add("init", "cmake_minimum_required(VERSION ${1:2.8.2})\nproject(${2:ProjectName})\n\nfind_package(${3:library})\n\ninclude_directories(${$3_INCLUDE_DIRS})\n\nadd_subdirectory(${0:src})\n\nadd_executable($2)\n\ntarget_link_libraries($2 ${$3_LIBRARIES})", "Initialize a basic CMake project with find_package, include_directories, add_subdirectory, add_executable, and target_link_libraries")
add("include", "include_directories(${${0:include_dir}})", "Add include directories to the build")
add("link", "target_link_libraries(${1:bin} ${0:somelib})", "Link libraries to a target")
add("Ext_url", "include(ExternalProject)\nExternalProject_Add(${1:googletest}\n\tURL ${2:http://googletest.googlecode.com/files/gtest-1.7.0.zip}\n\tURL_HASH SHA1=${3:f85f6d2481e2c6c4a18539e391aa4ea8ab0394af}\n\tSOURCE_DIR \"${4:${CMAKE_BINARY_DIR}/gtest-src}\"\n\tBINARY_DIR \"${0:${CMAKE_BINARY_DIR}/gtest-build}\"\n\tCONFIGURE_COMMAND \"\"\n\tBUILD_COMMAND     \"\"\n\tINSTALL_COMMAND   \"\"\n\tTEST_COMMAND      \"\"\n)", "Add an external project using a URL download (example: googletest 1.7.0)")
add("lib", "add_library(${1:lib} ${${0:srcs}})", "Add a library target to the build")

return snippets

