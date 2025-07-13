@tool
class_name Palette
extends Resource


@export var c := Color.CYAN
@export var m := Color.MAGENTA
@export var y := Color.YELLOW
@export var cm := Color.BLUE
@export var cy := Color.GREEN
@export var my := Color.RED
@export var cmy := Color.BLACK


func lookup(cyan: bool, magenta: bool, yellow: bool) -> Color:
    match [cyan, magenta, yellow]:
        [true, true, true]: return cmy
        [true, true, false]: return cm
        [true, false, true]: return cy
        [false, true, true]: return my
        [true, false, false]: return c
        [false, true, false]: return m
        [false, false, true]: return y
        _: return Color.WHITE