include("dijkstra.jl")
include("convertion.jl")
include("getImage.jl")
include("a_star.jl")

function main(test::String)

map::Matrix{Char} = convertion_F_M(test)
 

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

#Pair of coordinate=#
s_deb::Tuple{Int64,Int64} = (80,150)
s_fin::Tuple{Int64,Int64} = (853,926)

nodes_visitées::Vector{Tuple{Int64,Int64}} = []

println("Enter Dijkstra if you want to run Dijkstra or A_star if you wanna run a_star")

	algorithme_form = readline()
	if algorithme_form == "D" 

		@time dijkstra(map,passage_Matrix, s_deb, s_fin, pq, parent_Matrix, path, distM, nodes_visitées)
   		 
		Image_D::Matrix{Vector{Int64}} = Matrix{Vector{Int64}}(undef,size(map,1),size(map,2))
		imshow(converte_M_I(map,Image_D,Color,nodes_visitées,path))
		

	elseif algorithme_form == "A"
		@time a_star(map,passage_Matrix, s_deb, s_fin, pq, parent_Matrix, path, distM, nodes_visitées)

		Image::Matrix{Vector{Int64}} = Matrix{Vector{Int64}}(undef,size(map,1),size(map,2))
		imshow(converte_M_I(map,Image,Color,nodes_visitées,path))
		
	else 
		error("re-run the main in your repl. Then, enter a valid expression please")	
	end



end

