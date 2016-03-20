%Description: This function will retun the time for each path from current-node to destination-node. 
%This code might have some bugs 
%Hend AlTair - hend.altair@kustar.ac.ae 

function [time, path] = timeFunction_v1(agent1Actions,network,network_indices,currentLocation,targetLocation)
%accumelatedTime=0;%this what will be saved in the time array - the accumalated time of a whole path 

%first i will check if they are close to each other, else it will finish
%if(targetLocation-currentLocation!=1)
%accumelatedTime = accumelatedTime + calculateDistace(network_indices,currentLocation,targetLocation);

%currentLocation= currentLocation+1; 

%elseif(targetLocation-currentLocation==1)
%accumelatedTime = accumelatedTime + calculateDistace(network_indices,currentLocation,targetLocation);

%end 






%--------------------------------------------------------------------------------------------------------------------------------------------------- 
%--------------------------------------------------------------------------------------------------------------------------------------------------- 
%--------------------------------------------------------------------------------------------------------------------------------------------------- 
 accumelatedTime=0;%this what will be saved in the time array - the accumalated time of a whole path 
 time1=zeros;%this array will save the times of the different paths 
 path1=zeros;%this array should be an array of arrays of the different paths
 time2=zeros;%this array will save the times of the different paths 
 path2=zeros;%this array should be an array of arrays of the different paths
 possibleDirection=[];
 newlocation = currentLocation;
 previouslocation = newlocation; 
 
  for a=1:length(agent1Actions)
    %if (network(newlocation,a)!=newlocation)
      if(network(newlocation,a)!=targetLocation)
	if(network(newlocation,a)!=previouslocation)
	  accumelatedTime=accumelatedTime+calculateDistace(network_indices,newlocation,network(newlocation,a));
	  possibleDirection(a)=network(newlocation,a);
	  previouslocation = newlocation;
	  newlocation = network(newlocation,a)
	  time1(a)= accumelatedTime;
	  path1(a)= possibleDirection(a); 
	  %expandNode(agent1Actions, newlocation);
	end
      elseif(network(newlocation,a)==targetLocation)
	accumelatedTime = accumelatedTime+calculateDistace(network_indices,newlocation,targetLocation);
	possibleDirection(a)=targetLocation
	time2(a)= accumelatedTime;
	path2(a)= possibleDirection(a); 
	%break; 
      end
    %end

    
  end%end for loop 

  time1
  path1
 
  time2
  path2
 
 
  %---step1: check what are the the nodes connected to the current node---------------
  %  A* algorithm --> the distance + ecludian distance to destination. NOTE that A* takes the optimal (smallest cost of path) not as rewards 
  %expandNode(network_indices,agent1Actions,currentLocation);
  %---step2: loop to check the series of each connected node, if it takes me to next location----
  %call expand node, unless it return finish 

  %---step3: store the paths in an array to know the exact path, with a counter of how many paths are there 
  %---step4: caluclate the number of steps between one node and the next to it---------
  %calculateDistace(network_indices,currentLocation,nextLocation);
  %---step5: check the time for each of the avaiable paths and save the time and the path in array
  %time=x+y
  %path 
  
    
end%end function 
  