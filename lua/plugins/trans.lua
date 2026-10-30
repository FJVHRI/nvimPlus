-- ~/.config/nvim/lua/plugins/trans.lua

return {
  {
    "JuanZoran/Trans.nvim",
    enabled = false,
  },

  {
    name = "ecdict-offline",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    config = function()
      local dict_path = vim.fn.stdpath("config") .. "/dict/stardict.db"

      local function setup_highlights()
        local hl = vim.api.nvim_set_hl
        hl(0, "DictWord", { fg = "#5ef1ff", bold = true })
        hl(0, "DictPhonetic", { fg = "#ffeb87" })
        hl(0, "DictTranslation", { fg = "#5eff6e" })
        hl(0, "DictPos", { fg = "#ffbd5e", italic = true })
        hl(0, "DictExchangeTitle", { fg = "#bd5eff", bold = true })
        hl(0, "DictExchange", { fg = "#d5a3ff" })
        hl(0, "DictExampleTitle", { fg = "#ff6e5e", bold = true })
        hl(0, "DictExampleEn", { fg = "#ffffff" })
        hl(0, "DictExampleCn", { fg = "#5ef1ff" })
        hl(0, "DictNumber", { fg = "#ffff5e", bold = true })
        hl(0, "DictSeparator", { fg = "#5e5eff" })
        hl(0, "DictHint", { fg = "#7b8496" })
        hl(0, "DictBorder", { fg = "#5ef1ff" })
      end

      local function query_ecdict(word)
        if vim.fn.filereadable(dict_path) == 0 then
          return nil, "词典未找到"
        end
        local cmd = string.format(
          'sqlite3 "%s" "SELECT phonetic, translation, exchange, detail FROM stardict WHERE word = \'%s\' LIMIT 1"',
          dict_path,
          word:gsub("'", "''")
        )
        local output = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 or output == "" then
          return nil, "未找到"
        end
        local parts = vim.split(output:gsub("\n$", ""), "|", { plain = true })
        return {
          phonetic = parts[1] or "",
          translation = parts[2] or "",
          exchange = parts[3] or "",
          detail = parts[4] or "",
        }
      end

      local function fetch_youdao_examples(word)
        local encoded_word = word:gsub(" ", "%%20"):gsub("'", "%%27")
        local cmd = string.format(
          "curl -s -m 6 'https://dict.youdao.com/jsonapi?q=%s' -H 'User-Agent: Mozilla/5.0' 2>/dev/null",
          encoded_word
        )

        local output = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 or output == "" then
          return nil, "网络错误"
        end

        local ok, json = pcall(vim.json.decode, output)
        if not ok or type(json) ~= "table" then
          return nil, "解析失败"
        end

        local examples = {}

        if json.blng_sents_part and json.blng_sents_part["sentence-pair"] then
          for _, pair in ipairs(json.blng_sents_part["sentence-pair"]) do
            if #examples >= 3 then
              break
            end
            if pair.sentence and pair["sentence-translation"] then
              table.insert(examples, {
                en = pair.sentence,
                cn = pair["sentence-translation"],
              })
            end
          end
        end

        return #examples > 0 and examples or nil, "无例句"
      end

      -- 修改：直接流式播放，不缓存到本地文件
      local function play_word_audio(word, accent)
        local audio_type = accent == "us" and "1" or "2"
        local accent_label = accent == "us" and "美音" or "英音"
        local encoded_word = word:gsub(" ", "%%20")
        local url = string.format("https://dict.youdao.com/dictvoice?audio=%s&type=%s", encoded_word, audio_type)

        local play_cmd
        if vim.fn.executable("mpv") == 1 then
          -- mpv 直接播放 URL，无需缓存
          play_cmd = string.format("mpv --no-video --really-quiet '%s' &", url)
        elseif vim.fn.executable("ffplay") == 1 then
          -- ffplay 也支持直接播放 URL
          play_cmd = string.format("ffplay -nodisp -autoexit -timeout 6 '%s' 2>/dev/null &", url)
        else
          vim.notify("未找到 mpv 或 ffplay，无法播放音频", vim.log.levels.WARN)
          return
        end

        vim.fn.system(play_cmd)
        vim.notify("🔊 " .. accent_label, vim.log.levels.INFO, { timeout = 800 })
      end

      local function show_result(word, data, youdao_examples, error_msg)
        setup_highlights()
        local lines = {}
        local highlights = {}

        local function add_highlight(line_idx, group, start_col, end_col)
          table.insert(highlights, {
            line = line_idx,
            group = group,
            start = start_col or 0,
            finish = end_col or -1,
          })
        end

        local function add_line(text, hl_group, start_col, end_col)
          table.insert(lines, text)
          local idx = #lines - 1
          if hl_group then
            add_highlight(idx, hl_group, start_col, end_col)
          end
          return idx
        end

        add_line(
          "────────────────────────────────────────",
          "DictSeparator",
          0,
          -1
        )

        local word_part = "  " .. word
        local col_pos = 2 + #word

        if data.phonetic and data.phonetic ~= "" then
          word_part = word_part .. "  " .. data.phonetic
        end

        local hint = "[1]英 [2]美 [q]关"
        local remaining = 58 - #word_part - #hint
        if remaining < 2 then
          remaining = 2
        end
        word_part = word_part .. string.rep(" ", remaining) .. hint

        local line_idx = add_line(word_part)

        add_highlight(line_idx, "DictWord", 2, 2 + #word)
        if data.phonetic and data.phonetic ~= "" then
          local phonetic_start = 2 + #word + 2
          add_highlight(line_idx, "DictPhonetic", phonetic_start, phonetic_start + #data.phonetic)
        end

        local hint_start = #word_part - #hint
        add_highlight(line_idx, "DictNumber", hint_start, hint_start + 3)
        add_highlight(line_idx, "DictNumber", hint_start + 6, hint_start + 9)
        add_highlight(line_idx, "DictNumber", hint_start + 12, hint_start + 15)

        add_line(
          "────────────────────────────────────────",
          "DictSeparator",
          0,
          -1
        )

        if data.translation and data.translation ~= "" then
          for line in data.translation:gmatch("[^\n]+") do
            local idx = add_line("  " .. line)
            local pos_dot = line:find("%.")
            if pos_dot and pos_dot < 10 then
              add_highlight(idx, "DictPos", 2, pos_dot + 1)
              add_highlight(idx, "DictTranslation", pos_dot + 2, -1)
            else
              add_highlight(idx, "DictTranslation", 2, -1)
            end
          end
        end

        if data.exchange and data.exchange ~= "" then
          add_line(
            "────────────────────────────────────────",
            "DictSeparator",
            0,
            -1
          )
          add_line("  【词形变化】", "DictExchangeTitle", 2, -1)
          for part in data.exchange:gmatch("[^/]+") do
            local key, val = part:match("(.+):(.+)")
            if key and val then
              local labels = {
                p = "过去式",
                d = "过去分词",
                i = "现在分词",
                ["3"] = "三单",
                s = "复数",
                r = "比较级",
                t = "最高级",
              }
              local text = string.format("    %s: %s", labels[key] or key, val)
              local idx = add_line(text)
              local colon_pos = text:find(":")
              add_highlight(idx, "DictPos", 4, colon_pos - 1)
              add_highlight(idx, "DictExchange", colon_pos + 2, -1)
            end
          end
        end

        add_line(
          "────────────────────────────────────────",
          "DictSeparator",
          0,
          -1
        )
        add_line("  【例句】", "DictExampleTitle", 2, -1)

        if youdao_examples and #youdao_examples > 0 then
          for i, ex in ipairs(youdao_examples) do
            if i > 3 then
              break
            end
            local idx1 = add_line(string.format("  [%d] %s", i, ex.en))
            add_highlight(idx1, "DictNumber", 2, 5)
            add_highlight(idx1, "DictExampleEn", 6, -1)

            local idx2 = add_line("      " .. ex.cn)
            add_highlight(idx2, "DictExampleCn", 6, -1)

            if i < #youdao_examples then
              add_line("")
            end
          end
        else
          local msg = error_msg or "无数据"
          add_line("  [获取失败: " .. msg .. "]", "DictHint", 2, -1)
          add_line("  按 1/2 键发音，q 关闭", "DictHint", 2, -1)
        end

        add_line(
          "────────────────────────────────────────",
          "DictSeparator",
          0,
          -1
        )

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].filetype = "dictionary"
        vim.b[buf].dict_word = word

        local ns = vim.api.nvim_create_namespace("cyberdream_dict")
        for _, hl in ipairs(highlights) do
          vim.api.nvim_buf_add_highlight(buf, ns, hl.group, hl.line, hl.start, hl.finish)
        end

        local height = math.min(#lines + 2, vim.o.lines - 4)
        local width = math.min(60, vim.o.columns - 4)

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2,
          style = "minimal",
          border = "rounded",
          title = "通灵翻译",
          title_pos = "center",
        })

        vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:DictBorder")

        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
        vim.keymap.set("n", "1", function()
          local w = vim.b[buf].dict_word
          if w then
            play_word_audio(w, "uk")
          end
        end, { buffer = buf, silent = true })
        vim.keymap.set("n", "2", function()
          local w = vim.b[buf].dict_word
          if w then
            play_word_audio(w, "us")
          end
        end, { buffer = buf, silent = true })
      end

      local function translate(mode, input_word)
        local word
        if input_word then
          word = input_word
        elseif mode == "v" then
          local old_reg = vim.fn.getreg('"')
          vim.cmd('normal! ""y')
          word = vim.fn.getreg('"'):gsub("^%s*(.-)%s*$", "%1")
          vim.fn.setreg('"', old_reg)
        else
          word = vim.fn.expand("<cword>")
        end
        if not word or word == "" then
          return
        end

        vim.notify("查询: " .. word, vim.log.levels.INFO, { timeout = 500 })

        vim.defer_fn(function()
          local data = query_ecdict(word:lower())
          if not data then
            vim.notify("本地查询失败", vim.log.levels.WARN)
            return
          end

          local examples, err = fetch_youdao_examples(word)

          vim.schedule(function()
            show_result(word, data, examples, err)
          end)
        end, 10)
      end

      vim.keymap.set("n", "mm", function()
        translate("n")
      end, { desc = "词典查单词" })
      vim.keymap.set("v", "mm", function()
        translate("v")
      end, { desc = "词典查选中文本" })
      vim.keymap.set("n", "mi", function()
        vim.ui.input({ prompt = "输入单词: " }, function(input)
          if input then
            translate("n", input)
          end
        end)
      end, { desc = "词典输入查询" })
    end,
  },
}
