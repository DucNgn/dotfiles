-- 和紙 (washi) — warm light theme inspired by Japanese handmade paper
-- Cream background, sumi ink foreground, earthy palette
-- Matches the alacritty + tmux washi theme

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "washi"

local c = {
  -- Core
  bg        = "#f0f0ee",
  bg_dim    = "#e6e5e2",
  bg_float  = "#e0dfdc",
  bg_visual = "#c0bdb8",
  bg_cursor = "#e8e7e4",
  fg        = "#1a1816",
  fg_dim    = "#7a8279",
  fg_muted  = "#c0bdb8",
  active    = "#1a1816",

  -- ANSI / syntax
  red       = "#8a2820",
  red_br    = "#a04038",
  green     = "#2a5828",
  green_br  = "#4a7040",
  yellow    = "#6a5018",
  yellow_br = "#8a6e30",
  blue      = "#1a4a70",
  blue_br   = "#3a6488",
  magenta   = "#602060",
  magenta_br= "#7a4a7a",
  cyan      = "#1a5850",
  cyan_br   = "#3a7068",

  -- Diagnostics
  error     = "#8a2820",
  warn      = "#6a5018",
  info      = "#1a4a70",
  hint      = "#1a5850",
  ok        = "#2a5828",

  -- Git
  add       = "#2a5828",
  change    = "#1a4a70",
  delete    = "#8a2820",

  none      = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Editor ──────────────────────────────────────────────
hi("Normal",         { fg = c.fg, bg = c.bg })
hi("NormalFloat",    { fg = c.fg, bg = c.bg_float })
hi("NormalNC",       { fg = c.fg, bg = c.bg })
hi("Cursor",         { fg = c.bg, bg = c.fg })
hi("CursorLine",     { bg = c.bg_cursor })
hi("CursorLineNr",   { fg = c.active, bold = true })
hi("CursorColumn",   { bg = c.bg_cursor })
hi("ColorColumn",    { bg = c.bg_dim })
hi("LineNr",         { fg = c.fg_muted })
hi("SignColumn",     { bg = c.bg })
hi("FoldColumn",     { fg = c.fg_muted, bg = c.bg })
hi("Folded",         { fg = c.fg_dim, bg = c.bg_dim })
hi("VertSplit",      { fg = c.fg_muted })
hi("WinSeparator",   { fg = c.fg_muted })
hi("StatusLine",     { fg = c.fg, bg = c.bg_dim })
hi("StatusLineNC",   { fg = c.fg_dim, bg = c.bg_dim })
hi("TabLine",        { fg = c.fg_dim, bg = c.bg_dim })
hi("TabLineFill",    { bg = c.bg_dim })
hi("TabLineSel",     { fg = c.active, bg = c.bg, bold = true })
hi("WinBar",         { fg = c.fg, bg = c.bg })
hi("WinBarNC",       { fg = c.fg_dim, bg = c.bg })

-- ── Popup / Float ───────────────────────────────────────
hi("Pmenu",          { fg = c.fg, bg = c.bg_float })
hi("PmenuSel",       { fg = c.active, bg = c.bg_visual })
hi("PmenuSbar",      { bg = c.bg_dim })
hi("PmenuThumb",     { bg = c.fg_muted })
hi("FloatBorder",    { fg = c.fg_dim, bg = c.bg_float })
hi("FloatTitle",     { fg = c.active, bg = c.bg_float, bold = true })

-- ── Search / Match ──────────────────────────────────────
hi("Search",         { fg = c.active, bg = c.yellow_br, bold = true })
hi("IncSearch",      { fg = c.bg, bg = c.yellow })
hi("CurSearch",      { fg = c.bg, bg = c.yellow })
hi("Substitute",     { fg = c.bg, bg = c.red })
hi("Visual",         { bg = c.bg_visual })
hi("VisualNOS",      { bg = c.bg_visual })
hi("MatchParen",     { fg = c.active, bg = c.bg_visual, bold = true })

-- ── Messages ────────────────────────────────────────────
hi("ModeMsg",        { fg = c.fg, bold = true })
hi("MsgArea",        { fg = c.fg })
hi("MoreMsg",        { fg = c.green })
hi("WarningMsg",     { fg = c.warn })
hi("ErrorMsg",       { fg = c.error, bold = true })
hi("Question",       { fg = c.blue })
hi("Title",          { fg = c.active, bold = true })
hi("Directory",      { fg = c.blue })
hi("NonText",        { fg = c.fg_muted })
hi("SpecialKey",     { fg = c.fg_muted })
hi("Whitespace",     { fg = c.fg_muted })
hi("EndOfBuffer",    { fg = c.bg })
hi("Conceal",        { fg = c.fg_dim })

-- ── Diff ────────────────────────────────────────────────
hi("DiffAdd",        { bg = "#dde8d5" })
hi("DiffChange",     { bg = "#d8e4ee" })
hi("DiffDelete",     { bg = "#ead5d2" })
hi("DiffText",       { bg = "#c5d6e6", bold = true })

-- ── Spell ───────────────────────────────────────────────
hi("SpellBad",       { undercurl = true, sp = c.error })
hi("SpellCap",       { undercurl = true, sp = c.warn })
hi("SpellLocal",     { undercurl = true, sp = c.info })
hi("SpellRare",      { undercurl = true, sp = c.hint })

-- ── Diagnostics ─────────────────────────────────────────
hi("DiagnosticError",          { fg = c.error })
hi("DiagnosticWarn",           { fg = c.warn })
hi("DiagnosticInfo",           { fg = c.info })
hi("DiagnosticHint",           { fg = c.hint })
hi("DiagnosticOk",             { fg = c.ok })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.warn })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.info })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.hint })
hi("DiagnosticVirtualTextError", { fg = c.error, bg = "#ead5d2" })
hi("DiagnosticVirtualTextWarn",  { fg = c.warn, bg = "#e8e0cd" })
hi("DiagnosticVirtualTextInfo",  { fg = c.info, bg = "#d8e4ee" })
hi("DiagnosticVirtualTextHint",  { fg = c.hint, bg = "#d8e6e2" })

-- ── Syntax (base) ───────────────────────────────────────
hi("Comment",        { fg = c.fg_dim, italic = true })
hi("Constant",       { fg = c.magenta })
hi("String",         { fg = c.green })
hi("Character",      { fg = c.green })
hi("Number",         { fg = c.magenta })
hi("Boolean",        { fg = c.magenta })
hi("Float",          { fg = c.magenta })
hi("Identifier",     { fg = c.fg })
hi("Function",       { fg = c.blue })
hi("Statement",      { fg = c.red })
hi("Conditional",    { fg = c.red })
hi("Repeat",         { fg = c.red })
hi("Label",          { fg = c.red })
hi("Operator",       { fg = c.fg_dim })
hi("Keyword",        { fg = c.red, italic = true })
hi("Exception",      { fg = c.red })
hi("PreProc",        { fg = c.cyan })
hi("Include",        { fg = c.cyan })
hi("Define",         { fg = c.cyan })
hi("Macro",          { fg = c.cyan })
hi("PreCondit",      { fg = c.cyan })
hi("Type",           { fg = c.yellow })
hi("StorageClass",   { fg = c.yellow })
hi("Structure",      { fg = c.yellow })
hi("Typedef",        { fg = c.yellow })
hi("Special",        { fg = c.cyan })
hi("SpecialChar",    { fg = c.cyan })
hi("Tag",            { fg = c.blue })
hi("Delimiter",      { fg = c.fg_dim })
hi("SpecialComment", { fg = c.fg_dim, italic = true })
hi("Debug",          { fg = c.red })
hi("Underlined",     { underline = true })
hi("Bold",           { bold = true })
hi("Italic",         { italic = true })
hi("Ignore",         { fg = c.fg_muted })
hi("Error",          { fg = c.error })
hi("Todo",           { fg = c.yellow, bold = true })

-- ── Treesitter ──────────────────────────────────────────
hi("@variable",              { fg = c.fg })
hi("@variable.builtin",      { fg = c.magenta, italic = true })
hi("@variable.parameter",    { fg = c.fg })
hi("@variable.member",       { fg = c.fg })
hi("@constant",              { fg = c.magenta })
hi("@constant.builtin",      { fg = c.magenta, italic = true })
hi("@module",                { fg = c.cyan })
hi("@string",                { fg = c.green })
hi("@string.escape",         { fg = c.cyan })
hi("@string.regex",          { fg = c.cyan })
hi("@character",             { fg = c.green })
hi("@number",                { fg = c.magenta })
hi("@boolean",               { fg = c.magenta })
hi("@float",                 { fg = c.magenta })
hi("@function",              { fg = c.blue })
hi("@function.builtin",      { fg = c.blue, italic = true })
hi("@function.call",         { fg = c.blue })
hi("@function.method",       { fg = c.blue })
hi("@function.method.call",  { fg = c.blue })
hi("@constructor",           { fg = c.yellow })
hi("@keyword",               { fg = c.red, italic = true })
hi("@keyword.function",      { fg = c.red, italic = true })
hi("@keyword.return",        { fg = c.red, italic = true })
hi("@keyword.operator",      { fg = c.red })
hi("@keyword.import",        { fg = c.cyan })
hi("@keyword.conditional",   { fg = c.red })
hi("@keyword.repeat",        { fg = c.red })
hi("@keyword.exception",     { fg = c.red })
hi("@operator",              { fg = c.fg_dim })
hi("@punctuation",           { fg = c.fg_dim })
hi("@punctuation.bracket",   { fg = c.fg_dim })
hi("@punctuation.delimiter", { fg = c.fg_dim })
hi("@punctuation.special",   { fg = c.cyan })
hi("@type",                  { fg = c.yellow })
hi("@type.builtin",          { fg = c.yellow, italic = true })
hi("@type.definition",       { fg = c.yellow })
hi("@property",              { fg = c.fg })
hi("@attribute",             { fg = c.cyan })
hi("@tag",                   { fg = c.blue })
hi("@tag.attribute",         { fg = c.yellow })
hi("@tag.delimiter",         { fg = c.fg_dim })
hi("@comment",               { fg = c.fg_dim, italic = true })
hi("@comment.todo",          { fg = c.yellow, bold = true })
hi("@comment.note",          { fg = c.info, bold = true })
hi("@comment.warning",       { fg = c.warn, bold = true })
hi("@comment.error",         { fg = c.error, bold = true })
hi("@markup.heading",        { fg = c.active, bold = true })
hi("@markup.strong",         { bold = true })
hi("@markup.italic",         { italic = true })
hi("@markup.strikethrough",  { strikethrough = true })
hi("@markup.link",           { fg = c.blue, underline = true })
hi("@markup.link.url",       { fg = c.cyan, underline = true })
hi("@markup.raw",            { fg = c.green })
hi("@markup.list",           { fg = c.red })
hi("@markup.quote",          { fg = c.fg_dim, italic = true })

-- ── LSP semantic tokens ─────────────────────────────────
hi("@lsp.type.class",         { fg = c.yellow })
hi("@lsp.type.decorator",     { fg = c.cyan })
hi("@lsp.type.enum",          { fg = c.yellow })
hi("@lsp.type.enumMember",    { fg = c.magenta })
hi("@lsp.type.function",      { fg = c.blue })
hi("@lsp.type.interface",     { fg = c.yellow })
hi("@lsp.type.macro",         { fg = c.cyan })
hi("@lsp.type.method",        { fg = c.blue })
hi("@lsp.type.namespace",     { fg = c.cyan })
hi("@lsp.type.parameter",     { fg = c.fg })
hi("@lsp.type.property",      { fg = c.fg })
hi("@lsp.type.struct",        { fg = c.yellow })
hi("@lsp.type.type",          { fg = c.yellow })
hi("@lsp.type.variable",      { fg = c.fg })
hi("@lsp.mod.deprecated",     { strikethrough = true })

-- ── Git signs ───────────────────────────────────────────
hi("GitSignsAdd",    { fg = c.add })
hi("GitSignsChange", { fg = c.change })
hi("GitSignsDelete", { fg = c.delete })

-- ── Indent / guides ─────────────────────────────────────
hi("IndentBlanklineChar",        { fg = c.fg_muted })
hi("IndentBlanklineContextChar", { fg = c.fg_dim })
hi("IblIndent",                  { fg = c.fg_muted })
hi("IblScope",                   { fg = c.fg_dim })

-- ── Telescope ───────────────────────────────────────────
hi("TelescopeNormal",       { fg = c.fg, bg = c.bg_float })
hi("TelescopeBorder",       { fg = c.fg_dim, bg = c.bg_float })
hi("TelescopeTitle",        { fg = c.active, bold = true })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_dim })
hi("TelescopePromptBorder", { fg = c.fg_dim, bg = c.bg_dim })
hi("TelescopePromptTitle",  { fg = c.active, bold = true })
hi("TelescopeSelection",    { bg = c.bg_visual })
hi("TelescopeMatching",     { fg = c.blue, bold = true })

-- ── Snacks ──────────────────────────────────────────────
hi("SnacksDashboardHeader", { fg = c.fg_dim })
hi("SnacksDashboardFooter", { fg = c.fg_dim, italic = true })
hi("SnacksDashboardKey",    { fg = c.blue, bold = true })
hi("SnacksDashboardIcon",   { fg = c.blue })
hi("SnacksDashboardDesc",   { fg = c.fg })
hi("SnacksDashboardFile",   { fg = c.fg })

-- ── Mini ────────────────────────────────────────────────
hi("MiniStatuslineFilename",  { fg = c.fg, bg = c.bg_dim })
hi("MiniStatuslineDevinfo",   { fg = c.fg_dim, bg = c.bg_dim })
hi("MiniStatuslineFileinfo",  { fg = c.fg_dim, bg = c.bg_dim })
hi("MiniStatuslineModeNormal",  { fg = c.bg, bg = c.blue, bold = true })
hi("MiniStatuslineModeInsert",  { fg = c.bg, bg = c.green, bold = true })
hi("MiniStatuslineModeVisual",  { fg = c.bg, bg = c.magenta, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.bg, bg = c.yellow, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.bg, bg = c.red, bold = true })

-- ── Notify ──────────────────────────────────────────────
hi("NotifyERRORBorder", { fg = c.error })
hi("NotifyWARNBorder",  { fg = c.warn })
hi("NotifyINFOBorder",  { fg = c.info })
hi("NotifyDEBUGBorder", { fg = c.fg_dim })
hi("NotifyTRACEBorder", { fg = c.magenta })
hi("NotifyERRORIcon",   { fg = c.error })
hi("NotifyWARNIcon",    { fg = c.warn })
hi("NotifyINFOIcon",    { fg = c.info })
hi("NotifyDEBUGIcon",   { fg = c.fg_dim })
hi("NotifyTRACEIcon",   { fg = c.magenta })
hi("NotifyERRORTitle",  { fg = c.error, bold = true })
hi("NotifyWARNTitle",   { fg = c.warn, bold = true })
hi("NotifyINFOTitle",   { fg = c.info, bold = true })
hi("NotifyDEBUGTitle",  { fg = c.fg_dim, bold = true })
hi("NotifyTRACETitle",  { fg = c.magenta, bold = true })

-- ── Noice ───────────────────────────────────────────────
hi("NoiceCmdlinePopup",       { fg = c.fg, bg = c.bg_float })
hi("NoiceCmdlinePopupBorder", { fg = c.fg_dim })
hi("NoiceMini",               { fg = c.fg, bg = c.bg_dim })

-- ── Lazy ────────────────────────────────────────────────
hi("LazyButton",       { fg = c.fg, bg = c.bg_dim })
hi("LazyButtonActive", { fg = c.active, bg = c.bg_visual, bold = true })
hi("LazyH1",           { fg = c.bg, bg = c.blue, bold = true })

-- ── Which-key ───────────────────────────────────────────
hi("WhichKey",          { fg = c.blue })
hi("WhichKeyGroup",     { fg = c.cyan })
hi("WhichKeyDesc",      { fg = c.fg })
hi("WhichKeySeparator", { fg = c.fg_muted })
hi("WhichKeyValue",     { fg = c.fg_dim })
