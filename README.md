# projetL3_S2_Pathfinding

This is one of my last project during my third years of Bachelor's degree . I studied the problem of pathfinding, mentioned in particular in AI as well as operational research. In this approach to obtain the shortest path.  

I had to study Dijkstra and A*, two resolution algorithms, with numerical instances as lines of character representing a map.  
-----------------------------------------------------------------------------------------------------------
_To launch the project:_
   - The file conversion.jl contains a parser to convert a file in the map folder in dat. 
   - I'm using PyPlot and DataStructures packages
```julia
   Include("dijkstra.jl")
```
```julia
   Include("a_star.jl")
``` 
```julia
   algoDijkstra(“filename”, start_point , end_point)
```
```julia
   algoAstar(“filename”, start_point , end_point)
```
   (type of  stat_point and end_point: Tuple{Int64,Int64}) 
   
   
----------------------------------------------------------------------------------------------------------------

That should give you the shortest distance beetween those two points and how many points were traited.  
Finally It will display this type of map:  
- Tree in green  
- Accessible zone in beige  
- Unacessible zone in black  
- Water in blue  
- Shortest path in red  
- Visited zone in purple  
![theglaive_(50,250)_(400,380)_Astar](https://user-images.githubusercontent.com/101639883/225160668-ec8050bb-92ac-4f9a-a5a2-3a6c53a31e6f.png)

theglaive_(50,250)_(400,380) with A*  

