include("convertion.jl")
include("getImage.jl")

using DataStructures


#= Create a matrix of distance between start_node and each other nodes =#
function Initialisation(map::Matrix{Char}, x::Int64, y::Int64)
distM::Matrix{Int64} = fill(9999999999999,size(map,1),size(map,2))
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
		#= Same thing than my Dijkstra=#
		return 999999999999	
	end
end

#The only difference between dijkstra and A_star is that heuristique=#
function Manhattan_h(t2::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64})
    return (abs(s_fin[1] - t2[1])) + (abs(s_fin[2] - t2[2]))
end


#= Take two nodes as a tuple and update the distance beetween may start_Node and my t2_Node =#
function dist_update(t1::Tuple{Int64,Int64}, t2::Tuple{Int64,Int64}, distM::Matrix{Int64}, pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, map::Matrix{Char}, visited_nodes::Matrix{Bool}, s_fin::Tuple{Int64,Int64})
		
	acc::Int64 = 0
	if distM[t2[1],t2[2]] > distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		distM[t2[1],t2[2]] = distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		parent_Matrix[t2[1],t2[2]] = t1
		if( visited_nodes[t2[1],t2[2]] == false)
			visited_nodes[t2[1],t2[2]] = true
			acc += 1
		end	
	
		#= Was using enqueue! at the beginning but I changed. When you have to put a Node again in the 
		priority_queue with a lower distance, it fail. push! replace the actual node and change the priority=#
		
		push!(pq,t2 => distM[t2[1],t2[2]] + Manhattan_h(t2,s_fin))
		
		
	end
	return acc
end 

#= Once I am on my end_Node with the updated distance I just go up my parent_Matrix and put all nodes in a Vector.
	It represent my shortes path=#

function min_path(path::Vector{Tuple{Int64,Int64}}, start_Node::Tuple{Int64,Int64}, end_Node::Tuple{Int64,Int64}, parent_Matrix::Matrix{Tuple{Int64,Int64}},map::Matrix{Char})
		
	pushfirst!(path,end_Node)
	node::Tuple{Int64,Int64} = parent_Matrix[end_Node[1],end_Node[2]]
	
	while (node != start_Node) 
		
		pushfirst!(path,node)	
		#= don't change your char_Matrix =#
		node = parent_Matrix[node[1],node[2]]
	end
	 
	
	pushfirst!(path,start_Node)
	
	return path
	
end

#= Function that take all my data and calculate the shortest path. I will call it in algoAstar (algoAstar is like a
main  =#
function a_star(map::Matrix{Char}, passage_Matrix::Matrix{Bool}, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64}, pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, path::Vector{Tuple{Int64,Int64}}, distM::Matrix{Int64}, visited_nodes::Matrix{Bool}, acc_nodes::Int64)

  distM::Matrix{Int64} = Initialisation(map,s_deb[1],s_deb[2])

  #= Use a priority_queue here. Start by puting the  s_deb node with priority  0 in it =#
	
  enqueue!(pq,s_deb, distM[s_deb[1],s_deb[2]])

  s1::Tuple{Int64,Int64} = (0,0)
  
#=Start of main loop =#
while (passage_Matrix[s_fin[1],s_fin[2]] != 1 || empty!(pq))

	s1 =  dequeue!(pq)
		
	if s1 == s_fin 
		break
	end

	 	#=Passage_Matrix (state matrix) become true in the matrix at the position of the node you have dequeue
		this node have the shortest distance and his state become closed =#
		 passage_Matrix[s1[1],s1[2]] = 1
	
 	
	#=Check the neighbour in the clockwise direction, to optimise, I will create a function that replace 
		all my four conditions. acc_nodes represent the number of visited nodes as an accumulator=# 
		
    if  (s1[2]-1 > 0 && map[s1[1],s1[2]-1] != '@' && map[s1[1],s1[2]-1] != 'O' && map[s1[1],s1[2]-1] != 'T' 
         && passage_Matrix[s1[1],s1[2]-1] != 1)
		
        	acc_nodes += dist_update(s1,(s1[1],s1[2]-1), distM, pq, parent_Matrix, map, visited_nodes, s_fin)
		
	end

    if  (s1[1]-1 > 0 && map[s1[1]-1,s1[2]] != '@' && map[s1[1]-1,s1[2]] != 'O' 
             && map[s1[1]-1,s1[2]] != 'T' && passage_Matrix[s1[1]-1,s1[2]] != 1) 

		    acc_nodes += dist_update(s1,(s1[1]-1,s1[2]) , distM, pq, parent_Matrix, map, visited_nodes, s_fin)
		
	end
    
    if (s1[2]+1 <= size(map,2) && map[s1[1],s1[2]+1] != '@' && map[s1[1],s1[2]+1] != 'O' && map[s1[1],s1[2]+1] != 'T'
            && passage_Matrix[s1[1],s1[2]+1] != 1)
		
        	acc_nodes +=  dist_update(s1,(s1[1],s1[2]+1), distM,pq, parent_Matrix, map, visited_nodes, s_fin)
		
	end
    
    if (s1[1]+1 <= size(map,1) && map[s1[1]+1,s1[2]] != '@' && map[s1[1]+1,s1[2]] != 'O'
            && map[s1[1]+1,s1[2]] != 'T' && passage_Matrix[s1[1]+1,s1[2]] != 1) 
		
        	acc_nodes += dist_update(s1,(s1[1]+1,s1[2]), distM, pq, parent_Matrix, map, visited_nodes, s_fin)
		
	end

#= End of while=#
end

#= Call my function min_path that return the shortest path =# 
min_path(path, s_deb, s_fin, parent_Matrix,map)


println("The lowest path that you should take is"," ", distM[s_fin[1],s_fin[2]])
println(acc_nodes," "," nodes were visited during the algorithm","\n")
println("Here is the time of my Astar algorithm without the display of my Image:")
#= Useless here, I should remove the return =#
return visited_nodes
 
end



#=Main fonction=#
function algoAstar(test::String, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64} )

map::Matrix{Char} = convertion_F_M(test)
 
#= True when algo already pass the node =#
passage_Matrix::Matrix{Bool} = fill(false,size(map,1),size(map,2)) 
visited_nodes::Matrix{Bool} = fill(false,size(map,1),size(map,2))

#= Priority_queue=#
pq = PriorityQueue{Tuple{Int64,Int64}, Int64}()



#= Parent Matrix=#
parent_Matrix::Matrix{Tuple{Int64,Int64}} = Matrix{Tuple{Int64,Int64}}(undef,size(map,1),size(map,2))


#= My path that I will return with a_star=#
path::Vector{Tuple{Int64,Int64}} = []

#= Distance matrix=#
distM::Matrix{Int64} = Matrix{Int64}(undef,size(map,1),size(map,2))

#= Accumulator that count the number of visited nodes =#
acc_nodes::Int64 = 0

#= I call my main algorithme=#
#= Little detail, when I call my algorithm, I could check if the coordinates are not in a @ or 0 our out of the matrix and return an error("Retry")=#

@time a_star(map,passage_Matrix, s_deb, s_fin, pq, parent_Matrix, path, distM, visited_nodes, acc_nodes)

#= Display my Image =#
Image::Matrix{Vector{Int64}} = Matrix{Vector{Int64}}(undef,size(map,1),size(map,2))
imshow(converte_M_I(map,Image,Color,visited_nodes,path))
	
end








		    
