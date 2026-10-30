-- Generated from markdown.json by scripts/convert-snippets.lua. Do not edit by hand.
-- Edit the source JSON and re-run the converter, or edit here and remove the JSON.
local ls = require("luasnip")
local s, parse = ls.snippet, ls.parser.parse_snippet

local snippets = {}

local function add(trigger, body, description)
  local ok, snip = pcall(parse, { trig = trigger, name = trigger, dscr = description }, body)
  if ok and snip then table.insert(snippets, snip) end
end

add("gist-full", "{% gist ${1:gist_id} ${0:filename} %}", "Insert an Octopress gist with ID and filename")
add("[\"", "[${1:text}](https://${2:address} \"${3:title}\")", "Insert a link with title")
add("gist-short", "{% gist ${0:gist_id} %}", "Insert a short Octopress gist with ID")
add("![*", "![${1:alt}](${2:`@*`})", "Insert an image with clipboard URL")
add("[\"*", "[${1:link}](${2:`@*`} \"${3:title}\")", "Insert a link with title and clipboard URL")
add("img", "{% img ${1:class} ${2:URL} ${3:width} ${4:height} ${5:title_text} ${0:alt_text} %}", "Insert an Octopress image tag")
add("__", "__$0__", "Insert bold text")
add("youtube", "{% youtube ${0:video_id} %}", "Insert an Octopress YouTube tag")
add("---", "---\n$0\n---", "Insert Jekyll front matter")
add("![\"", "![${1:alttext}](${2:/images/image.jpg} \"${3:title}\")", "Insert an image with title")
add("====", "`repeat('=', strlen(getline(line('.') - 3)))`\n\n${0}", "Insert a heading with === underline")
add("![\"*", "![${1:alt}](${2:`@*`} \"${3:title}\")", "Insert an image with title and clipboard URL")
add("-", "-   ${0}", "Insert a list item")
add("pullquote", "{% pullquote %}\n${1:text} {\" ${2:quote} \"} ${0:text}\n{% endpullquote %}", "Insert an Octopress pullquote (see http://octopress.org/docs/plugins/pullquote/)")
add("----", "`repeat('-', strlen(getline(line('.') - 3)))`\n\n${0}", "Insert a heading with --- underline")
add("![\"c", "![${1:alt}](${2:`@+`} \"${3:title}\")", "Insert an image with title and clipboard URL (c)")
add("blockquote", "{% blockquote %}\n${0:quote}\n{% endblockquote %}", "Insert an Octopress blockquote")
add(":", "$1\n: $0", "Insert a definition list")
add("![:", "![${1:id}]: ${2:url}", "Insert a reference image")
add("blockquote-author", "{% blockquote ${1:author}, ${2:title} %}\n${0:quote}\n{% endblockquote %}", "Insert an Octopress blockquote with author and title")
add("![:*", "![${1:id}]: ${2:`@*`}", "Insert a reference image with clipboard URL")
add("blockquote-link", "{% blockquote ${1:author} ${2:URL} ${3:link_text} %}\n${0:quote}\n{% endblockquote %}", "Insert an Octopress blockquote with author, URL and link text")
add("![:\"", "![${1:id}]: ${2:url} \"${3:title}\"", "Insert a reference image with title")
add("```", "\\`\\`\\`${1}\n${0:${VISUAL}}\n\\`\\`\\`", "Insert a fenced code block")
add("[:", "[${1:id}]: https://${2:url}", "Insert a reference link")
add("tb", "|  ${0:factors}      |    ${1:a}       |  ${2:b}   |\n| ------------- |-------------  | ------- |\n|    ${3:f1}    |    Y          | N       |\n|    ${4:f2}    |    Y          | N       |", "Insert a table")
add("[:c", "[${1:id}]: ${2:`@+`}", "Insert a reference link with clipboard URL (c)")
add("![c", "![${1:alt}](${2:`@+`})", "Insert an image with clipboard URL (c)")
add("![:\"*", "![${1:id}]: ${2:`@*`} \"${3:title}\"", "Insert a reference image with title and clipboard URL")
add("codeblock-short", "{% codeblock %}\n${0:code_snippet}\n{% endcodeblock %}", "Insert a short Octopress codeblock")
add("[:\"", "[${1:id}]: https://${2:url} \"${3:title}\"", "Insert a reference link with title")
add("```l", "\\`\\`\\`${1:language}\n${2:code}\n\\`\\`\\`", "Insert a fenced code block with language")
add("[\"c", "[${1:link}](${2:`@+`} \"${3:title}\")", "Insert a link with title and clipboard URL (c)")
add("[c", "[${1:link}](${2:`@+`})", "Insert a link with clipboard URL (c)")
add("![:\"c", "![${1:id}]: ${2:`@+`} \"${3:title}\"", "Insert a reference image with title and clipboard URL (c)")
add("**", "**$0**", "Insert bold text")
add("[:\"*", "[${1:id}]: ${2:`@*`} \"${3:title}\"", "Insert a reference link with title and clipboard URL")
add("[", "[${1:text}](${2:address})", "Insert a link")
add("[*", "[${1:link}](${2:`@*`})", "Insert a link with clipboard URL")
add("![", "![${1:alttext}](${2:/images/image.jpg})", "Insert an image")
add("<", "<http://${1:url}>", "Insert an angle bracket link")
add("[:*", "[${1:id}]: ${2:`@*`}", "Insert a reference link with clipboard URL")
add("[:\"c", "[${1:id}]: ${2:`@+`} \"${3:title}\"", "Insert a reference link with title and clipboard URL (c)")
add("codeblock-full", "{% codeblock ${1:title} lang:${2:language} ${3:URL} ${4:link_text} %}\n${0:code_snippet}\n{% endcodeblock %}", "Insert a full Octopress codeblock with title, language, URL and link text")
add("<*", "<`@*`>", "Insert an angle bracket link with clipboard URL")
add("<c", "<`@+`>", "Insert an angle bracket link with clipboard URL (c)")
add("::", "$1\n  - $0", "Insert an alternate definition list")

return snippets

