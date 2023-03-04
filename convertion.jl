function convertion_F_M(map::String)

open(map,"r") do io
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

function converte_M_V_F(map::Matrix{Char})
	V::Vector{String} = []
	for i in 1:size(map,1), j in 1:size(map,2)
	
		V[i][j] = map[i,j]
	end 

	open("test.map","w")
		write(tmp,V)
	close(tmp)
end
