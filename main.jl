include("dijkstra.jl")

include("convertion.jl")

function main()
map::Matrix{Char} = convertion_F_M("divideandconquer.map")
 

#= weight of my character for [.,G,@,O,T,S,V] and create it =#

#=
weight_character::Vector{Int64} = [1,1,999999,999999,999999,5,8]		 
transition_Matrix::Matrix{Int64} = fill_transition_Matrix(weight_character)
=#

#= true when algo already pass the node =#
passage_Matrix::Matrix{Bool} = fill(false,size(map,1),size(map,2)) 


#= Priority_queue=#
pq = PriorityQueue{Tuple{Int64,Int64}, Int64}()


#= Parent Matrix=#
parent_Matrix::Matrix{Tuple{Int64,Int64}} = Matrix{Tuple{Int64,Int64}}(undef,size(map,1),size(map,2))

#= My path that I will return with dijkstra=#
path::Vector{Tuple{Int64,Int64}} = []

#= distance matrix=#
distM::Matrix{Int64} = Matrix{Int64}(undef,size(map,1),size(map,2))

#Pair of point=#
s_deb::Tuple{Int64,Int64} = (49,64)
s_fin::Tuple{Int64,Int64} = (450,450)


dijkstra(map,passage_Matrix, s_deb, s_fin, pq, parent_Matrix, path, distM)

	
	

end

