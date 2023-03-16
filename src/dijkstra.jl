include("convertion.jl")
include("getImage.jl")

using DataStructures

#= Create a matrix of distance between start_node and each other nodes =#
function Initialisation(map::Matrix{Char}, x::Int64, y::Int64)
distM::Matrix{Int64} = fill(9999999999,size(map,1),size(map,2))
distM[x,y] = 0
return distM
end 

#= Take two nodes as two tuples and return the weight of the second node=#
function weight_transition(map::Matrix{Char}, c1::Tuple{Int64,Int64}, c2::Tuple{Int64,Int64})
	A::Char = map[c2[1],c2[2]]
	if (A == '.')  return 1 
	elseif (A == 'G') return 1 
	elseif (A == 'W') return 8 
	elseif (A == 'S') return 5 
 	else
        #= Ndt: that work, however that's not a good way att all. I will change it during the seconde 
		part. I should/will create a dictionnary=#
		return 9999999	
	end
end

#= Take two nodes as a tuple and update the distance beetween may start_Node and my t2_Node =#
function dist_update(t1::Tuple{Int64,Int64}, t2::Tuple{Int64,Int64}, distM::Matrix{Int64},pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, map::Matrix{Char}, visited_nodes::Matrix{Bool})
		
	acc::Int64 = 0
	if distM[t2[1],t2[2]] > distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		distM[t2[1],t2[2]] = distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		parent_Matrix[t2[1],t2[2]] = t1
	
		if visited_nodes[t2[1],t2[2]] == false
			visited_nodes[t2[1],t2[2]] = true
			 acc +=1
		end
		
		#= Was using enqueue! at the beginning but I changed. When you have to put a Node again in the 
		priority_queue with a lower distance, it fail. push! replace the actual node and change the priority=#
		
		
		push!(pq,t2 => distM[t2[1],t2[2]])
		
		
	end
	return acc
end 

#= Once I am on my end_Node with the updated distance I just go up my parent_Matrix and put all nodes in a Vector.
	It represent my shortes path=#

function min_path(path::Vector{Tuple{Int64,Int64}}, start_Node::Tuple{Int64,Int64}, end_Node::Tuple{Int64,Int64}, parent_Matrix::Matrix{Tuple{Int64,Int64}},map::Matrix{Char},)
		

	pushfirst!(path,end_Node)
	node::Tuple{Int64,Int64} = parent_Matrix[end_Node[1],end_Node[2]]
	
	while (node != start_Node) 
		
		pushfirst!(path,node)
		node = parent_Matrix[node[1],node[2]]
	end

	pushfirst!(path,start_Node)
	
	return path
	
end

#= Function that take all my data and calculate the shortest path. I will call it in algoDijkstra (algoDijkstra is like a main  =#
function dijkstra(map::Matrix{Char}, passage_Matrix::Matrix{Bool}, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64}, pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, path::Vector{Tuple{Int64,Int64}}, distM::Matrix{Int64}, visited_nodes::Matrix{Bool}, acc_nodes::Int64)

  distM::Matrix{Int64} = Initialisation(map,s_deb[1],s_deb[2])

  #= Use a priority_queue here. Start by puting the  s_deb node with priority  0 in it =#
	
  enqueue!(pq,s_deb, distM[s_deb[1],s_deb[2]])

  s1::Tuple{Int64,Int64} = (0,0)

  #=Start of  main loop =#
  while (passage_Matrix[s_fin[1],s_fin[2]] != 1 || empty!(pq))

	
	s1 =  dequeue!(pq)
		

	if s1 == s_fin 
		break
	end

	 
		 passage_Matrix[s1[1],s1[2]] = 1
	
 	#=Passage_Matrix (state matrix) become true in the matrix at the position of the node you have dequeue
		this node have the shortest distance and his state become closed =#	
    
    #=Check the neighbour in this direction: (up,down,right,left). To optimise, I will create a function that replace 
		all my four conditions. acc_nodes represent the number of visited nodes as an accumulator=# 

	if  (s1[1]+1 <= size(map,1) && map[s1[1]+1,s1[2]] != '@' && map[s1[1]+1,s1[2]] != 'O' 
         && map[s1[1]+1,s1[2]] != 'T' && passage_Matrix[s1[1]+1,s1[2]] != 1) 

		acc_nodes += dist_update(s1,(s1[1]+1,s1[2]) , distM, pq, parent_Matrix, map, visited_nodes)
		
	end
    
	if  (s1[1]-1 > 0 && map[s1[1]-1,s1[2]] != '@' && map[s1[1]-1,s1[2]] != 'O' && map[s1[1]-1,s1[2]] != 'T' 
         && passage_Matrix[s1[1]-1,s1[2]] != 1)
		
        	acc_nodes += dist_update(s1,(s1[1]-1,s1[2]), distM, pq, parent_Matrix, map, visited_nodes)
		
	end
    
    if (s1[2]+1 <= size(map,2) && map[s1[1],s1[2]+1] != '@' && map[s1[1],s1[2]+1] != 'O'
            && map[s1[1],s1[2]+1] != 'T' && passage_Matrix[s1[1],s1[2]+1] != 1) 
		
        	acc_nodes += dist_update(s1,(s1[1],s1[2]+1), distM, pq, parent_Matrix, map, visited_nodes)
		
	end
    
    if (s1[2]-1 > 0 && map[s1[1],s1[2]-1] != '@' && map[s1[1],s1[2]-1] != 'O' && map[s1[1],s1[2]-1] != 'T'
            && passage_Matrix[s1[1],s1[2]-1] != 1)
		
        	acc_nodes += dist_update(s1,(s1[1],s1[2]-1), distM,pq, parent_Matrix, map, visited_nodes)
		
	end

#= End of while=#
  end
#= Call my function min_path that return the shortest path =# 
min_path(path, s_deb, s_fin, parent_Matrix,map)

println("The lowest path that you should take is"," ", distM[s_fin[1],s_fin[2]])
println(acc_nodes," "," nodes were visited during the algorithm")
println("Here is the time of my Dijkstra algorithm without the display of my Image:")
 
end


#= Main function =#
function algoDijkstra(test::String, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64} )

map::Matrix{Char} = convertion_F_M(test)
 
#= True when algo already pass the node =#
passage_Matrix::Matrix{Bool} = fill(false,size(map,1),size(map,2)) 
visited_nodes::Matrix{Bool} = fill(false,size(map,1),size(map,2))

#= Priority_queue=#
pq = PriorityQueue{Tuple{Int64,Int64}, Int64}()



#= Parent Matrix=#
parent_Matrix::Matrix{Tuple{Int64,Int64}} = Matrix{Tuple{Int64,Int64}}(undef,size(map,1),size(map,2))


#= My path that I will return with dijkstra=#
path::Vector{Tuple{Int64,Int64}} = []

#= Distance matrix=#
distM::Matrix{Int64} = Matrix{Int64}(undef,size(map,1),size(map,2))


#= Accumulator that count the number of visited nodes =#
acc_nodes::Int64 = 0


#= I call my main algorithme=#
@time dijkstra(map,passage_Matrix, s_deb, s_fin, pq, parent_Matrix, path, distM, visited_nodes, acc_nodes)  		 

Image_D::Matrix{Vector{Int64}} = Matrix{Vector{Int64}}(undef,size(map,1),size(map,2))
imshow(converte_M_I(map,Image_D,Color,visited_nodes,path))
		
end






		    
