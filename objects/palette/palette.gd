@tool
class_name Palette
extends Resource


@export var r := Color.RED
@export var g := Color.GREEN
@export var b := Color.BLUE
@export var rg := Color.YELLOW
@export var gb := Color.CYAN
@export var rb := Color.MAGENTA
@export var rgb := Color.WHITE


func lookup(red: bool, green: bool, blue: bool) -> Color:
    match [red, green, blue]:
        [true, true, true]: return rgb
        [true, true, false]: return rg
        [true, false, true]: return rb
        [false, true, true]: return gb
        [true, false, false]: return r
        [false, true, false]: return g
        [false, false, true]: return b
        _: return Color.BLACK