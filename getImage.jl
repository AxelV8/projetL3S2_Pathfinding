using PyPlot


Color::Dict{Char,Vector{Int64}} = Dict( '.' => [225,206,154],
				    '@' => [0,0,0],
				    'T' => [34,120,15],
				    'W' => [16,52,166],
				    'G' => [233,201,177],
				    'O' => [0,0,0],
				    'S' => [44,117,255])


function converte_M_I(map::Matrix{Char}, Image::Matrix{Vector{Int64}}, Color::Dict{Char,Vector{Int64}}, nodes_visitées::Matrix{Bool}, path::Vector{Tuple{Int64,Int64}})
	#= Changer avec les vecteurs  =#
	for i in 1:size(map,1),j in 1:size(map,2)
		if (nodes_visitées[i,j] == true)
			Image[i,j] = [127,0,255]
		else	
			Image[i,j] = get!(Color, map[i,j], [255,255,255])
		end
	end
	#=for i in 1:length(nodes_visitées)
		Image[(nodes_visitées[i])[1],(nodes_visitées[i])[2]] = [127,0,255]
	 
	end=#
	for j in 1:length(path)
		Image[(path[j])[1],(path[j])[2]] = [172,30,68]
	end	
return Image
end
	
