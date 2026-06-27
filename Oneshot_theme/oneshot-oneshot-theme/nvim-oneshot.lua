local c = vim.g.oneshot_palette or {
  bg          = "#070324",
  fg          = "#e8d5b7",
  gold        = "#d4a54a",
  gold_bright = "#f0c860",
  surface     = "#0f0544",
  container   = "#2b0e77",
  base        = "#5f2680",
  border      = "#1a0544",
  red         = "#e07a5f",
  green       = "#8bba7a",
  blue        = "#4a6a9a",
  magenta     = "#c4a0b0",
  cyan        = "#6a9a9a",
  cream_dim   = "#b8a88a",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal",         { fg = c.fg, bg = c.bg })
hl("NormalFloat",    { fg = c.fg, bg = c.container })
hl("NormalSB",       { fg = c.fg, bg = c.bg })

hl("Comment",        { fg = c.cream_dim, italic = true })
hl("Todo",           { fg = c.bg, bg = c.gold })
hl("Note",           { fg = c.fg, bg = c.blue })

hl("Constant",       { fg = c.gold })
hl("String",         { fg = c.green })
hl("Character",      { fg = c.green })
hl("Number",         { fg = c.gold_bright })
hl("Boolean",        { fg = c.gold_bright })
hl("Float",          { fg = c.gold_bright })

hl("Identifier",     { fg = c.magenta })
hl("Function",       { fg = c.blue })

hl("Statement",      { fg = c.gold })
hl("Conditional",    { fg = c.gold })
hl("Repeat",         { fg = c.gold })
hl("Label",          { fg = c.gold })
hl("Operator",       { fg = c.gold })
hl("Keyword",        { fg = c.gold })
hl("Exception",      { fg = c.red })

hl("PreProc",        { fg = c.magenta })
hl("Include",        { fg = c.magenta })
hl("Define",         { fg = c.magenta })
hl("Macro",          { fg = c.magenta })

hl("Type",           { fg = c.cyan })
hl("StorageClass",   { fg = c.cyan })
hl("Structure",      { fg = c.cyan })
hl("Typedef",        { fg = c.cyan })

hl("Special",        { fg = c.blue })
hl("SpecialChar",    { fg = c.blue })
hl("Delimiter",      { fg = c.fg })
hl("SpecialComment", { fg = c.cream_dim })

hl("Underlined",     { fg = c.blue, underline = true })
hl("Bold",           { bold = true })
hl("Italic",         { italic = true })

hl("Error",          { fg = c.red, bg = c.bg })
hl("ErrorMsg",       { fg = c.red })
hl("WarningMsg",     { fg = c.gold_bright })
hl("MoreMsg",        { fg = c.blue })
hl("ModeMsg",        { fg = c.fg })

hl("Pmenu",          { fg = c.fg, bg = c.surface })
hl("PmenuSel",       { fg = c.bg, bg = c.gold })
hl("PmenuSbar",      { bg = c.surface })
hl("PmenuThumb",     { bg = c.gold })

hl("Cursor",         { fg = c.bg, bg = c.gold })
hl("CursorLine",     { bg = c.surface })
hl("CursorLineNr",   { fg = c.gold, bg = c.surface })
hl("CursorColumn",   { bg = c.surface })

hl("LineNr",         { fg = c.cream_dim })
hl("SignColumn",     { fg = c.cream_dim, bg = c.bg })

hl("Visual",         { bg = c.container })
hl("VisualNOS",      { bg = c.container })

hl("Search",         { fg = c.bg, bg = c.gold_bright })
hl("IncSearch",      { fg = c.bg, bg = c.gold })

hl("StatusLine",     { fg = c.fg, bg = c.surface })
hl("StatusLineNC",   { fg = c.cream_dim, bg = c.surface })
hl("TabLine",        { fg = c.cream_dim, bg = c.bg })
hl("TabLineSel",     { fg = c.bg, bg = c.gold })
hl("TabLineFill",    { bg = c.bg })

hl("SpellBad",       { sp = c.red, undercurl = true })
hl("SpellCap",       { sp = c.blue, undercurl = true })
hl("SpellLocal",     { sp = c.cyan, undercurl = true })
hl("SpellRare",      { sp = c.magenta, undercurl = true })

hl("DiffAdd",        { fg = c.green, bg = c.surface })
hl("DiffChange",     { fg = c.gold, bg = c.surface })
hl("DiffDelete",     { fg = c.red, bg = c.surface })
hl("DiffText",       { fg = c.blue, bg = c.surface })

hl("NonText",        { fg = c.cream_dim })
hl("SpecialKey",     { fg = c.cream_dim })
hl("Whitespace",     { fg = c.surface })
hl("EndOfBuffer",    { fg = c.bg })

hl("Folded",         { fg = c.cream_dim, bg = c.surface })
hl("FoldColumn",     { fg = c.cream_dim, bg = c.bg })

hl("WinSeparator",   { fg = c.border, bg = c.bg })
hl("VertSplit",      { fg = c.border })

vim.g.colors_name = "oneshot"
