extends Node

signal request_tooltip_signal(data : TooltipData)

func request_tooltip(data : TooltipData):
	request_tooltip_signal.emit(data)
