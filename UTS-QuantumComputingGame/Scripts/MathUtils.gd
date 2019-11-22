class_name MathUtils

static func tensor_product(vec_a,  vec_b):
	var product = Array()
	for value in vec_a:
		for other in vec_b:
			product.append(value * other)
	return product

static func tensor(vectors):
	var tensor = tensor_product(vectors[0], vectors[1])
	for i in range(1, vectors.size()):
		if i < vectors.size() - 1:
				tensor = tensor_product(tensor, vectors[i + 1])
	return tensor

static func flip_bits(bits, mat):
	var tensor = tensor_product([0,1], bits)
	return mat.get_product(mat, tensor)

static func create_mat4(rows):
	return Mat4.new(rows)

static func to_binary(number, rows):
	var bits = Array()
	for i in range(0, rows):
		bits.append(0)
	var idx = 0
	while number != 0:
		bits[idx] = (number % 2)
		number = number / 2
		idx += 1
	bits.invert()
	return bits

static func kronecker(first, second):
	var rows = Array()
	for i in range(0, first.matrix.size()):
		var row = first.matrix[i]
		for other in second.matrix:
			rows.append(tensor([row, other]))
	return create_mat4(rows)

static func get_identity_matrix():
	return create_mat4([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])

static func get_reverse_identity_matrix():
	return create_mat4([[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]])