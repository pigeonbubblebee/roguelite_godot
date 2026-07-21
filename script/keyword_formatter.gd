class_name KeywordFormatter

const icon_path = "res://assets/ui/inline_icons/"
const colored_text = false

static var KEYWORDS := {
	"STR": {
		"color": C_ColorPalette.RED,
		"icon": icon_path + "str_icon.png"
	},
	"DEX": {
		"color": C_ColorPalette.YELLOW,
		"icon": icon_path + "dex_icon.png"
	},
	"INT": {
		"color": C_ColorPalette.BLUE,
		"icon": icon_path + "int_icon.png"
	},
	"VIG": {
		"color": C_ColorPalette.GREEN,
		"icon": icon_path + "vig_icon.png"
	},
	"DEF": {
		"color": C_ColorPalette.CYAN,
		"icon": icon_path + "def_icon.png"
	},
	"ARC": {
		"color": C_ColorPalette.PURPLE,
		"icon": icon_path + "arc_icon.png"
	},
	"FTH": {
		"color": C_ColorPalette.ORANGE,
		"icon": icon_path + "fth_icon.png"
	},
	"Neutral": {
		"color": C_ColorPalette.GREY,
		"icon": icon_path + "neu_icon.png"
	},
	"COMMON": {
		"color": C_ColorPalette.WHITE,
		"icon": icon_path + "neu_icon.png"
	},
	"RARE": {
		"color": C_ColorPalette.GREEN,
		"icon": icon_path + "neu_icon.png"
	},
	"HEROIC": {
		"color": C_ColorPalette.YELLOW,
		"icon": icon_path + "neu_icon.png"
	},
}

static var DAMAGE_TYPE_COLORS := {
	DamageType.Type.PHYSICAL: {
		"color": C_ColorPalette.RED,
	},
	DamageType.Type.FIRE: {
		"color": C_ColorPalette.ORANGE,
	},
	DamageType.Type.COLD: {
		"color": C_ColorPalette.CYAN,
	},
	DamageType.Type.LIGHTNING: {
		"color": C_ColorPalette.YELLOW,
	},DamageType.Type.MAGIC: {
		"color": C_ColorPalette.BLUE,
	}
}

static var ARMOR_COLOR = C_ColorPalette.CYAN

static func format_text(text: String) -> String:
	for keyword in KEYWORDS.keys():
		var data = KEYWORDS[keyword]
		
		var regex = RegEx.new()
		regex.compile("\\b%s\\b" % keyword)

		var icon_tag = "[img=14x14 valign=center]%s[/img]" % data.icon
		var colored = "[color=%s]%s[/color]" % [data.color, keyword]
		# "" could be (colored if colored_text else keyword)
		var replacement = "%s%s" % [icon_tag, colored] #icon_tag, colored

		text = regex.sub(text, replacement, true)

	return text
	
static func get_keyword_color(keyword: String):
	return KEYWORDS[keyword].color

static func format_damage_text(label: Label, ctx: DamageContext):
	var color = DAMAGE_TYPE_COLORS[ctx.damage_type].color
	
	label.add_theme_color_override("font_color", color)

static func format_armor_text(label: Label):
	var color = ARMOR_COLOR
	label.add_theme_color_override("font_color", color)
	
static func format_status_description(template: String, stacks: int) -> String:
	var regex = RegEx.new()
	regex.compile("\\{([^}]*)\\}")
	
	var result = template
	
	var matches = regex.search_all(template)
	
	for m in matches:
		var expr = m.get_string(1)
		var value = evaluate_expression(expr, stacks)
		result = result.replace("{" + expr + "}", str(value))
	
	return result

static func evaluate_expression(expr: String, stacks: int):
	expr = expr.replace("STACKS", str(stacks))
	
	var expression = Expression.new()
	var err = expression.parse(expr)
	
	if err != OK:
		return "?"
	
	return expression.execute()
