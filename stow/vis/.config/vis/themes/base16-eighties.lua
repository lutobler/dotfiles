-- base16-vis (https://github.com/pshevtsov/base16-vis)
-- by Petr Shevtsov
-- Eighties scheme by Chris Kempson (http://chriskempson.com)

local lexers = vis.lexers

local colors = {
	['base00'] = '#2d2d2d',
	['base01'] = '#393939',
	['base02'] = '#515151',
	['base03'] = '#747369',
	['base04'] = '#a09f93',
	['base05'] = '#d3d0c8',
	['base06'] = '#e8e6df',
	['base07'] = '#f2f0ec',
	['base08'] = '#f2777a',
	['base09'] = '#f99157',
	['base0A'] = '#ffcc66',
	['base0B'] = '#99cc99',
	['base0C'] = '#66cccc',
	['base0D'] = '#6699cc',
	['base0E'] = '#cc99cc',
	['base0F'] = '#d27b53',
}

lexers.colors = colors

local fg = ',fore:'..colors.base05..','
local bg = ',back:'..colors.base00..','

lexers.STYLE_DEFAULT = bg..fg
lexers.STYLE_NOTHING = bg
lexers.STYLE_CLASS = 'fore:'..colors.base0A
-- lexers.STYLE_COMMENT = 'fore:'..colors.base03..',italics'
lexers.STYLE_COMMENT = 'fore:'..colors.base03
lexers.STYLE_CONSTANT = 'fore:'..colors.base09
lexers.STYLE_DEFINITION = 'fore:'..colors.base0E
lexers.STYLE_ERROR = 'fore:'..colors.base08..',italics'
lexers.STYLE_FUNCTION = 'fore:'..colors.base0D
lexers.STYLE_KEYWORD = 'fore:'..colors.base0E --
lexers.STYLE_LABEL = 'fore:'..colors.base0A
lexers.STYLE_NUMBER = 'fore:'..colors.base09
lexers.STYLE_OPERATOR = 'fore:'..colors.base05
lexers.STYLE_REGEX = 'fore:'..colors.base0C
lexers.STYLE_STRING = 'fore:'..colors.base0B
lexers.STYLE_PREPROCESSOR = 'fore:'..colors.base0D --
lexers.STYLE_TAG = 'fore:'..colors.base0A
lexers.STYLE_TYPE = 'fore:'..colors.base0A
lexers.STYLE_VARIABLE = 'fore:'..colors.base0D
lexers.STYLE_WHITESPACE = 'fore:'..colors.base02
lexers.STYLE_EMBEDDED = 'fore:'..colors.base0F
lexers.STYLE_IDENTIFIER = 'fore:'..colors.base05 --

lexers.STYLE_LINENUMBER = 'fore:'..colors.base02..',back:'..colors.base00
lexers.STYLE_CURSOR = 'fore:'..colors.base00..',back:'..colors.base05
lexers.STYLE_CURSOR_PRIMARY = 'fore:'..colors.base00..',back:'..colors.base05
lexers.STYLE_CURSOR_LINE = 'back:'..colors.base01
lexers.STYLE_COLOR_COLUMN = 'back:'..colors.base01
lexers.STYLE_SELECTION = 'back:'..colors.base02
lexers.STYLE_STATUS = 'fore:'..colors.base04..',back:'..colors.base01
lexers.STYLE_STATUS_FOCUSED = 'fore:'..colors.base09..',back:'..colors.base01
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'fore:default,back:default,bold'
lexers.STYLE_EOF = ''
