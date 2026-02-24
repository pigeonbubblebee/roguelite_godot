extends Camera2D

var _shake_timer: float
var _base_position: Vector2
var _shake_magnitude: float
	
var _rng: RandomNumberGenerator
	
var _noise: FastNoiseLite
var _noiseI: float

func _ready() -> void:
	_noise = _noise.new()
	_noise.Seed = randf()

	_rng = _rng.new();

func _shake(time: float, magnitude: float) -> void:
	_noise.Seed = randf()
	_base_position = global_position;
	_shake_timer = time;
	_shake_magnitude = magnitude * 0.12;
	

func _process(delta) -> void:
	_shake_magnitude = lerp(_shake_magnitude, 0, 5 * delta)
	
	if _shake_timer > 0:
		offset = _get_noise(delta);
		_shake_timer -= delta;
	if _shake_timer <= 0:
		offset = Vector2.ZERO

func _get_noise(delta) -> Vector2:
	_noiseI += delta * 60

	return Vector2(
		_noise.GetNoise2D(1, _noiseI) * _shake_magnitude, 
		_noise.GetNoise2D(100, _noiseI) * _shake_magnitude
	)
