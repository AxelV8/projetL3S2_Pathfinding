

using DataStructures



#= function fill_transition_Matrix(v::Vector{Int64})
tmp::Matrix{Int64}= Matrix{Int64}(undef,length(v),length(v))
for i in 1:length(v), j in 1:length(v)
	tmp[i,j] = v[j]

end
return tmp
end
=#




#= Create a matrix of distance between start_node and each other nodes =#
function Initialisation(map::Matrix{Char}, x::Int64, y::Int64)
distM::Matrix{Int64} = fill(9999999999,size(map,1),size(map,2))
distM[x,y] = 0
return distM
end 

#= take two nodes as a tuple and return the weight of the second node=#
function weight_transition(map::Matrix{Char}, c1::Tuple{Int64,Int64}, c2::Tuple{Int64,Int64})
	A::Char = map[c2[1],c2[2]]
	if (A == '.')  return 1 
	elseif (A == 'G') return 1 
	elseif (A == 'W') return 8 
	elseif (A == 'S') return 5 
 	else
		return 9999999	
	end
end

#= take two nodes as a tuple and update the distance beetween may start_Node and my t2_Node =#
function dist_update(t1::Tuple{Int64,Int64}, t2::Tuple{Int64,Int64}, distM::Matrix{Int64},pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, map::Matrix{Char}, nodes_visitées::Vector{Tuple{Int64,Int64}})
		
	
	if distM[t2[1],t2[2]] > distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		distM[t2[1],t2[2]] = distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		parent_Matrix[t2[1],t2[2]] = t1
	 	pushfirst!(nodes_visitées, t2)	
		
		#= enqueue! at the beginning but I change because when you have to put a Node again in the 
		priority_queue with a lower distance, it fail. push replace the actual node and cahnge the priority=#
		
		
		push!(pq,t2 => distM[t2[1],t2[2]])
		
		
	end
	
end 

#= Une fois que dijsktra est fini on a notre parent_matrice qui est good avec les distances on va chercher le plus court chemin cette fois avec la fun qui renvoi un vecteur de node =#

#= Once I m on my end_Node with the updated distance I just go up my parent_Matrix and put all nodes in a Vector
	then I will create a graphic interface to Display my map with the path=#

function min_path(path::Vector{Tuple{Int64,Int64}}, start_Node::Tuple{Int64,Int64}, end_Node::Tuple{Int64,Int64}, parent_Matrix::Matrix{Tuple{Int64,Int64}},map::Matrix{Char})
		

	pushfirst!(path,end_Node)
	node::Tuple{Int64,Int64} = parent_Matrix[end_Node[1],end_Node[2]]
	
	while (node != start_Node) 
		
		pushfirst!(path,node)
		node = parent_Matrix[node[1],node[2]]
	end

	pushfirst!(path,start_Node)
	
	return path
	
end

#= Main function=#
function dijkstra(map::Matrix{Char}, passage_Matrix::Matrix{Bool}, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64}, pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, path::Vector{Tuple{Int64,Int64}}, distM::Matrix{Int64}, nodes_visitées::Vector{Tuple{Int64,Int64}})

  distM::Matrix{Int64} = Initialisation(map,s_deb[1],s_deb[2])

  #=On utilise une priority_queue, on commence par mettre le node[x,y] avec priority 0 de debut dedans =#
	
  enqueue!(pq,s_deb, distM[s_deb[1],s_deb[2]])
  
 
  #=On commence la boucle:=#
  s1::Tuple{Int64,Int64} = (0,0)
  
  while (passage_Matrix[s_fin[1],s_fin[2]] != 1)

	
	s1 =  dequeue!(pq)
		

	if s1 == s_fin 
		break
	end

	 
		 passage_Matrix[s1[1],s1[2]] = 1
	
 	#=si le passage_matrix[s1[1],s1[2]] a son passage a false alors on le met a vrai=# 
	#= modif le robot n est pas tarzan: ajouter comme condition si la node est un Tree je le check pas =#	
    
	if  (s1[1]+1 <= size(map,1) && map[s1[1]+1,s1[2]] != '@' && map[s1[1]+1,s1[2]] != 'O' 
             && map[s1[1]+1,s1[2]] != 'T' && passage_Matrix[s1[1]+1,s1[2]] != 1) 

		dist_update(s1,(s1[1]+1,s1[2]) , distM, pq, parent_Matrix, map, nodes_visitées)
		
	end
    
	if  (s1[1]-1 > 0 && map[s1[1]-1,s1[2]] != '@' && map[s1[1]-1,s1[2]] != 'O' && map[s1[1]-1,s1[2]] != 'T' 
         && passage_Matrix[s1[1]-1,s1[2]] != 1)
		
        	dist_update(s1,(s1[1]-1,s1[2]), distM, pq, parent_Matrix, map, nodes_visitées)
		
	end
    
        if (s1[2]+1 <= size(map,2) && map[s1[1],s1[2]+1] != '@' && map[s1[1],s1[2]+1] != 'O'
            && map[s1[1],s1[2]+1] != 'T' && passage_Matrix[s1[1],s1[2]+1] != 1) 
		
        	dist_update(s1,(s1[1],s1[2]+1), distM, pq, parent_Matrix, map, nodes_visitées)
		
	end
    
    	if (s1[2]-1 > 0 && map[s1[1],s1[2]-1] != '@' && map[s1[1],s1[2]-1] != 'O' && map[s1[1],s1[2]-1] != 'T'
            && passage_Matrix[s1[1],s1[2]-1] != 1)
		
        	dist_update(s1,(s1[1],s1[2]-1), distM,pq, parent_Matrix, map, nodes_visitées)
		
	end

#= end of while=#
  end

min_path(path, s_deb, s_fin, parent_Matrix,map)

println("The lowest path that you should take is"," ", distM[s_fin[1],s_fin[2]])
println(length(nodes_visitées)," "," nodes were traited during the algorithm")

return nodes_visitées
 
end







		    
