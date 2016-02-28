%Description: This function will retun the time for each path from current-node to destination-node. 
%This code might have some bugs 
%Hend AlTair - hend.altair@kustar.ac.ae 

function [time, path] = timeFunction_v1(agent1Loc,network,network_indices,currentLocation,targetLocation)
  time=[];
  path=[];
  possibleDirection=[];
  %---step1: check what are the the nodes connected to the current node---------------
  %  A* algorithm --> the distance + ecludian distance to destination. NOTE that A* takes the optimal (smallest cost of path) not as rewards 
  for x=1:length(agent1Loc)
    index=1; 
    if (network(currentLocation,x)!=currentLocation)
      if(network(currentLocation,x)!=targetLocation)
	possibleDirection(index)=network(currentLocation,x);
	index++; 
      elseif(network(currentLocation,x)==targetLocation)
	time=x+y
	path 
      end
    end
  end 
  %---step2: loop to check the series of each connected node, if it takes me to next location----
  %call expand node, unless it return finish 
      for y=1:length(possibleDirection)
	possibleDirection(y)
      end 
  %---step3: store the paths in an array to know the exact path, with a counter of how many paths are there 
  %---step4: caluclate the number of steps between one node and the next to it---------
  x=(network_indices(currentLocation,1)-network_indices(nextLocation,1));
  y=(network_indices(currentLocation,2)-network_indices(nextLocation,2));
  %---step5: check the time for each of the avaiable paths and save the time and the path in array
  time=x+y
  path 
  
    
end%end function 
  