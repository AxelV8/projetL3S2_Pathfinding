

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

function dist_update(t1::Tuple{Int64,Int64}, t2::Tuple{Int64,Int64}, distM::Matrix{Int64},pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, map::Matrix{Char})
		

	if distM[t2[1],t2[2]] > distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		distM[t2[1],t2[2]] = distM[t1[1],t1[2]] + weight_transition(map,t1,t2)
		
		parent_Matrix[t2[1],t2[2]] = t1
		
		enqueue!(pq,t2,distM[t2[1],t2[2]])
	end
end 

#= Une fois que dijsktra est fini on a notre parent_matrice qui est good avec les distances on va chercher le plus court chemin cette fois avec la fun qui renvoi un vecteur de node =#


 function min_path(path::Vector{Tuple{Int64,Int64}}, start_Node::Tuple{Int64,Int64}, end_Node::Tuple{Int64,Int64}, parent_Matrix::Matrix{Tuple{Int64,Int64}},map::Matrix{Char})
	
	map[end_Node[1],end_Node[2]] = 'F'	

	pushfirst!(path,end_Node)
	node::Tuple{Int64,Int64} = parent_Matrix[end_Node[1],end_Node[2]]

	println(node)

	while (node != start_Node) 
		
		
		pushfirst!(path,node)
		
		map[node[1],node[2]] = 'X'
		
		node = parent_Matrix[node[1],node[2]]
	end
	map[start_Node[1],start_Node[2]] = 'D' 
	
	pushfirst!(path,start_Node)
	println(path)
	return path
	
end


function dijkstra(map::Matrix{Char}, passage_Matrix::Matrix{Bool}, s_deb::Tuple{Int64,Int64}, s_fin::Tuple{Int64,Int64}, pq, parent_Matrix::Matrix{Tuple{Int64,Int64}}, path::Vector{Tuple{Int64,Int64}}, distM::Matrix{Int64} )

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
	
    
	if  (s1[1]+1 <= size(map,1) && map[s1[1]+1,s1[2]] != '@' && map[s1[1]+1,s1[2]] != 'O') 
		dist_update(s1,(s1[1]+1,s1[2]) ,distM,pq, parent_Matrix, map)
	end
    
	if  (s1[1]-1 > 0 && map[s1[1]-1,s1[2]] != '@' && map[s1[1]-1,s1[2]] != 'O')
		dist_update(s1,(s1[1]-1,s1[2]),distM,pq, parent_Matrix, map)
	end
    
    	if (s1[2]+1 <= size(map,2) && map[s1[1],s1[2]+1] != '@' && map[s1[1],s1[2]+1] != 'O') 
		dist_update(s1,(s1[1],s1[2]+1), distM,pq, parent_Matrix, map)
	end
    
    	if (s1[2]-1 > 0 && map[s1[1],s1[2]-1] != '@' && map[s1[1],s1[2]-1] != 'O')
		dist_update(s1,(s1[1],s1[2]-1), distM,pq, parent_Matrix, map)
	end
	#= checker aussi si les voisins sont des caracteres out of bound @ 0 T 
		la on regarde pour ses voisins (x+1)< size(map,1) (x-1)>0 (y+1)<size(map,2) (y-1)>0, 
		on check si les x et y ne sont pas hors de la matrice comme au dessus,
	=#

	#=si on est bon alors on appel la fun maj_distances(node1[s1.x,s1.y],node2[x+1,y]) et on fait ca pour tout les 		voisins	On revient au debut de la boucle tant que, etc.... =#
#= end of while=#
  end

min_path(path, s_deb, s_fin, parent_Matrix,map)

println("La plus petite distance entre s_deb et s_fin est"," ", distM[s_fin[1],s_fin[2]])
 
end







		    
