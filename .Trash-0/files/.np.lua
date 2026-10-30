print("PROBE_START")
local ok, mod = pcall(require, "noice.config")
print("require noice.config ok=" .. tostring(ok))
if ok then
  local C = mod.options
  print("cmdline.view=" .. tostring(C.cmdline and C.cmdline.view))
  print("bottom_search=" .. tostring(C.presets and C.presets.bottom_search))
  print("search_down.view=" .. tostring(C.cmdline and C.cmdline.format and C.cmdline.format.search_down and C.cmdline.format.search_down.view))
end
print("PROBE_END")
