class_name Mat4
var matrix = Array()

func _init(rows):
	matrix = rows

static func get_product(matrix, vector):
	if matrix.matrix.size() == vector.size():
		for row in matrix.matrix:
			var end_value = 0
			var vec_idx = 0
			for val in row:
				end_value += val * vector[vec_idx]
				vec_idx+=1
			print(end_value)
	else:
		print("Invalid product sizes! Vector must have same column size as matrix rows!")