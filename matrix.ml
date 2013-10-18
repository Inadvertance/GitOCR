let make = Array.make_matrix
let columns = Array.length
let lines x = Array.length x.(0)
let get_dims mat = (columns mat, lines mat)