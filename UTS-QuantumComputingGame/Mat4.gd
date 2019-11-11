class_name Mat4

var matrix = Array()

func _init():
	var row_1 = [1, 0, 0, 0]
	var row_2 = [0, 1, 0, 0]
	var row_3 = [0, 0, 0, 1]
	var row_4 = [0, 0, 1, 0]
	matrix = [row_1, row_2, row_3, row_4]

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