function convertion_F_M(map::String)
test = "../dat/map/"*map
open(test,"r") do io
	v::Vector{String} = readlines(io)
 
	height::Int64= parse(Int64,split(v[2], " ")[2])
	width::Int64=  parse(Int64,split(v[3], " ")[2])



	M::Matrix{Char} = Matrix{Char}(undef,height,width)

								#= Fill my matrix =#
	for i in  1:(height), j in 1:width
 
		c::Char = v[i+4][j]
		M[i,j] = c
	end

	return M
end
end


