-- ~/.config/nvim/lua/plugins/snippets.lua
return {
    ---------------------------------------------------------------------------
    -- ①  nvim-cmp  ⇢  MUST load immediately (no lazy event)
    ---------------------------------------------------------------------------
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        priority = 1000,
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "vsnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },

    ---------------------------------------------------------------------------
    -- ②  vim-vsnip  ⇢  light snippet engine
    ---------------------------------------------------------------------------
    {
        "hrsh7th/vim-vsnip",
        lazy = false,
        dependencies = { "hrsh7th/nvim-cmp" },
    },

    ---------------------------------------------------------------------------
    -- ③  friendly-snippets  ↳ plus custom visual-mode builder
    ---------------------------------------------------------------------------
    {
        "rafamadriz/friendly-snippets",
        event = "VeryLazy",
        dependencies = "hrsh7th/vim-vsnip",

        config = function()
            ---------------------------------------------------------------------
            -- local helpers
            ---------------------------------------------------------------------
            local SNIPPET_FILE = vim.fn.expand("~/.config/nvim/snippets/sql.json")

            -- trim each line + swap double→single quotes (no extra commas/quotes)
            local function clean(lines)
                for i, l in ipairs(lines) do
                    lines[i] = vim.trim(l):gsub('"', "'")
                end
                return lines
            end

            -- pretty JSON encoding compatible with old / new NVim APIs
            -- pretty-print JSON even on old NVim; respects strings, escapes, etc.
            local function encode_pretty(tbl)
                -- 1️⃣  try the official 2-arg encoder (NVim ≥ 0.10)
                if vim.json and vim.json.encode then
                    local ok, res = pcall(vim.json.encode, tbl, { indent = 2 })
                    if ok then
                        return res
                    end
                end

                -- 2️⃣  compact fallback
                local compact = (vim.json and vim.json.encode) and vim.json.encode(tbl) or vim.fn.json_encode(tbl)

                -- 3️⃣  already pretty? bail early
                if compact:find("\n") then
                    return compact
                end

                --------------------------------------------------------------------
                -- 4️⃣  manual pretty-printer (indent aware, string-safe)
                --------------------------------------------------------------------
                local indent, lvl, out = "  ", 0, {}
                local in_str, escape = false, false

                for i = 1, #compact do
                    local ch = compact:sub(i, i)

                    if in_str then
                        table.insert(out, ch)
                        if escape then
                            escape = false -- escaped char, reset flag
                        elseif ch == "\\" then
                            escape = true -- next char is escaped
                        elseif ch == '"' then
                            in_str = false -- end of string
                        end
                    else
                        if ch == '"' then
                            in_str = true
                            table.insert(out, ch)
                        elseif ch == "{" or ch == "[" then
                            lvl = lvl + 1
                            table.insert(out, ch .. "\n" .. string.rep(indent, lvl))
                        elseif ch == "}" or ch == "]" then
                            lvl = lvl - 1
                            table.insert(out, "\n" .. string.rep(indent, lvl) .. ch)
                        elseif ch == "," then
                            table.insert(out, ch .. "\n" .. string.rep(indent, lvl))
                        elseif ch == ":" then
                            table.insert(out, ch .. " ")
                        else
                            table.insert(out, ch)
                        end
                    end
                end

                return table.concat(out)
            end

            ---------------------------------------------------------------------
            -- main action
            ---------------------------------------------------------------------
            local function create_snippet()
                -------------------------------------------------------------------------
                -- grab visual text -----------------------------------------------------
                -------------------------------------------------------------------------
                vim.cmd([[silent normal! "vy]])
                local raw = vim.fn.getreg("v")
                if raw == "" then
                    vim.notify("🤔  Nothing selected", vim.log.levels.WARN)
                    return
                end
                local body = clean(vim.split(raw, "\n"))

                -------------------------------------------------------------------------
                -- ask the user ---------------------------------------------------------
                -------------------------------------------------------------------------
                local title = vim.fn.input("Snippet title      : ")
                if title == "" then
                    return
                end
                local new_prefix = vim.fn.input("Prefix trigger     : ")
                local desc = vim.fn.input("Description (opt.) : ", "Structure")

                -------------------------------------------------------------------------
                -- open / decode the json ----------------------------------------------
                -------------------------------------------------------------------------
                local ok, data = pcall(function()
                    if vim.fn.filereadable(SNIPPET_FILE) == 1 then
                        return vim.json.decode(table.concat(vim.fn.readfile(SNIPPET_FILE), "\n"))
                    end
                    return {}
                end)
                if not ok or type(data) ~= "table" then
                    data = {}
                end

                -------------------------------------------------------------------------
                -- CASE A: title already exists  → overwrite everything -----------------
                -------------------------------------------------------------------------
                if data[title] then
                    local old_prefix = data[title].prefix or "<none>"
                    local answer = vim.fn.input(
                        string.format(
                            "Snippet '%s' exists (prefix '%s'). Overwrite completely? [y/N]: ",
                            title,
                            old_prefix
                        )
                    )
                    if answer:lower():sub(1, 1) ~= "y" then
                        vim.notify("  Aborted: snippet unchanged", vim.log.levels.INFO)
                        return
                    end
                    data[title] = { prefix = new_prefix, body = body, description = desc }

                -------------------------------------------------------------------------
                -- CASE B: brand-new title  → check prefix clashes ----------------------
                -------------------------------------------------------------------------
                else
                    local dup_key
                    for k, v in pairs(data) do
                        if v.prefix == new_prefix then
                            dup_key = k
                            break
                        end
                    end
                    if dup_key then
                        local ans = vim.fn.input(
                            string.format(
                                "Another snippet '%s' already uses prefix '%s'. Delete old & continue? [y/N]: ",
                                dup_key,
                                new_prefix
                            )
                        )
                        if ans:lower():sub(1, 1) == "y" then
                            data[dup_key] = nil
                        else
                            vim.notify("  Aborted: duplicate prefix", vim.log.levels.INFO)
                            return
                        end
                    end
                    data[title] = { prefix = new_prefix, body = body, description = desc }
                end

                -------------------------------------------------------------------------
                -- write, copy, done ----------------------------------------------------
                -------------------------------------------------------------------------
                vim.fn.writefile(vim.split(encode_pretty(data), "\n"), SNIPPET_FILE)
                vim.fn.setreg("+", encode_pretty({ [title] = data[title] }))
                vim.notify("✅  Snippet saved (prefix & body updated) — clipboard ready", vim.log.levels.INFO)
            end

            ---------------------------------------------------------------------
            -- keymap
            ---------------------------------------------------------------------
            vim.keymap.set("v", "<leader>s", create_snippet, { desc = "Create / update snippet (sql.json)" })
        end,
    },
}
