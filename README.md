# projetL3_S2_Pathfinding

This is one of my last project during my third years of Bachelor's degree . I studied the problem of pathfinding, mentioned in particular in AI as well as operational research. In this approach to obtain the shortest path.

I had to study Dijsktra and A*, two resolution algorithms, with numerical instances as lines of character representing a map.

To launch the project:
    - The file conversion.jl contains a parser to convert a file in the map folder.
    - Include the main.jl file in the REPL.
    - Then launch the main function with the main parameter(“filename”, start_point , end_point). 
      (type of point: Tuple{Int64,Int64})
    - You will have the choice beetween what do you want to run.

That should give you the shortest distance beetween those two points and how many points were traited.
Finally It will display this type of map:
- Tree in green
- accessible zone in beige
- uncassible zone in black
- Water in blue
- shortest path in red
- traited points in purple
![Berlin_0_1024_(16,42)_(981,982)_a_star](https://user-images.githubusercontent.com/101639883/224394094-fec16611-8cac-48bf-82ae-d240a9d05a6d.png)
