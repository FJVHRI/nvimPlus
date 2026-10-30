vim.defer_fn(function()
  local C = require("noice.config").options
  print("cmdline.view = " .. tostring(C.cmdline.view))
  print("search_down.view = " .. tostring(C.cmdline.format.search_down and C.cmdline.format.search_down.view))
  print("search_up.view   = " .. tostring(C.cmdline.format.search_up and C.cmdline.format.search_up.view))
  print("presets.bottom_search = " .. tostring(C.presets.bottom_search))
  print("cmdline_popup pos = " .. vim.inspect(C.views.cmdline_popup and C.views.cmdline_popup.position))
  vim.cmd("qa!")
end, 300)
