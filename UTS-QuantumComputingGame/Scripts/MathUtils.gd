class_name MathUtils

static func tensor_product(vec_a,  vec_b):
	var product = Array()
	for value in vec_a:
		for other in vec_b:
			product.append(value * other)
	return product

static func flip_bits(bits, mat):
	var tensor = tensor_product([0,1], bits)
	return mat.get_product(mat, tensor)

static func get_significant_bits(vector):
	var significant_bits = Array()
	
	if (vector[0] != 0 and vector[vector.size()-1] != 0) and (vector[1] == 0 and vector[2] == 0):
		significant_bits = vector
	elif vector[0] == 0 and vector[0] == 0:
		significant_bits = [vector[vector.size() -2], vector[vector.size() -1]]
	else:
		significant_bits = [vector[0], vector[1]]
	return significant_bits

static func create_mat4(rows):
	return Mat4.new(rows)