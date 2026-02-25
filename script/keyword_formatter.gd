class_name KeywordFormatter

const icon_path = "res://assets/ui/inline_icons/"
const colored_text = false

static var KEYWORDS := {
	"STR": {
		"color": ColorPalette.RED,
		"icon": icon_path + "str_icon.png"
	},
	"DEX": {
		"color": ColorPalette.YELLOW,
		"icon": icon_path + "dex_icon.png"
	},
	"INT": {
		"color": ColorPalette.BLUE,
		"icon": icon_path + "int_icon.png"
	},
	"VIG": {
		"color": ColorPalette.GREEN,
		"icon": icon_path + "vig_icon.png"
	},
	"DEF": {
		"color": ColorPalette.CYAN,
		"icon": icon_path + "def_icon.png"
	},
	"ARC": {
		"color": ColorPalette.PURPLE,
		"icon": icon_path + "arc_icon.png"
	},
}

static var DAMAGE_TYPE_COLORS := {
	DamageType.Type.PHYSICAL: {
		"color": ColorPalette.RED,
	},
	DamageType.Type.FIRE: {
		"color": ColorPalette.ORANGE,
	},
	DamageType.Type.COLD: {
		"color": ColorPalette.CYAN,
	},
	DamageType.Type.LIGHTNING: {
		"color": ColorPalette.YELLOW,
	},DamageType.Type.MAGIC: {
		"color": ColorPalette.BLUE,
	}
}

static var ARMOR_COLOR = ColorPalette.CYAN

static func format_text(text: String) -> String:
	for keyword in KEYWORDS.keys():
		var data = KEYWORDS[keyword]
		
		var regex = RegEx.new()
		regex.compile("\\b%s\\b" % keyword)

		var icon_tag = "[img=14x14 valign=center]%s[/img]" % data.icon
		var colored = "[color=%s]%s[/color]" % [data.color, keyword]
		var replacement = "%s%s" % [icon_tag, colored if colored_text else keyword] #icon_tag, colored

		text = regex.sub(text, replacement, true)

	return text

static func format_damage_text(label: Label, ctx: DamageContext):
	var color = DAMAGE_TYPE_COLORS[ctx.damage_type].color
	
	label.add_theme_color_override("font_color", color)

static func format_armor_text(label: Label):
	var color = ARMOR_COLOR
	label.add_theme_color_override("font_color", color)
