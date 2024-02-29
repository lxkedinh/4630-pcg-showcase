extends Node2D

@export var width : int = 128
@export var height : int = 128

@export var height_noise_texture : NoiseTexture2D
var height_noise : Noise

@export var tree_noise_texture : NoiseTexture2D
var tree_noise : Noise

@export var grass_noise_threshold : float = 0.0
@export var tall_grass_noise_threshold : float = 0.2
@export var tree_noise_threshold : float = 0.8

var water_layer = 0
var water_source_id = 1
var water_atlas = Vector2i(0,0)

var grass_layer = 1
var grass_source_id = 0
var terrain_set_grass = 0
var grass_tiles = []

var grass_variety_layer = 2
var grass_varieties_atlas = []

var tree_layer = 3
var tree_source_id = 2
var tree_atlas = Vector2i(1,0)


func _init():
	gen_grass_varieties()	

func _ready():
	height_noise = height_noise_texture.noise
	tree_noise = tree_noise_texture.noise
	gen_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func gen_level():
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			set_water_tile(x,y)
			var height_noise_val = height_noise.get_noise_2d(x, y)
			var tree_noise_val = tree_noise.get_noise_2d(x,y)
			
			if height_noise_val >= grass_noise_threshold:
				grass_tiles.append(Vector2i(x,y))
				
				if tree_noise_val >= tree_noise_threshold:
					set_tree(x,y)
				
			if height_noise_val >= tall_grass_noise_threshold:
					set_rand_grass_variety(x,y)
	
	set_grass_terrain()
	
func set_water_tile(x, y):
	$TileMap.set_cell(water_layer, Vector2(x,y), water_source_id, water_atlas)
	
func set_grass_terrain():
	$TileMap.set_cells_terrain_connect(grass_layer, grass_tiles, terrain_set_grass, 0)

func gen_grass_varieties():
	for x in range(0, 6):
		grass_varieties_atlas.append(Vector2i(x,5))
		grass_varieties_atlas.append(Vector2i(x,6))

func set_rand_grass_variety(x, y):
	$TileMap.set_cell(grass_variety_layer, Vector2(x,y), grass_source_id, grass_varieties_atlas.pick_random())

func set_tree(x,y):
	$TileMap.set_cell(tree_layer, Vector2(x,y), tree_source_id, tree_atlas)
