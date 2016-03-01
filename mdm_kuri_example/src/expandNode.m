function [] = expandNode(agent1Actions) 
 accumelatedTime=0;%this what will be saved in the time array - the accumalated time of a whole path 
 time=[];%this array will save the times of the different paths 
 path=[];%this array should be an array of arrays of the different paths
 possibleDirection=[];
 newlocation = currentLocation;
 
  for a=1:length(agent1Actions)
    if (network(newlocation,a)!=currentLocation)
      if(network(newlocation,a)!=targetLocation)
	accumelatedTime=accumelatedTime+calculateDistace(network_indices,currentLocation,nextLocation);
	possibleDirection(a)=network(newlocation,a);
	newlocation = network(newlocation,a);
      elseif(network(currentLocation,a)==targetLocation)
	nextLocation = targetLocation;
	accumelatedTime = accumelatedTime+calculateDistace(network_indices,currentLocation,nextLocation);
	possibleDirection(a)=network(currentLocation,a);
	time= accumelatedTime;
	path= possibleDirection(a); 
	break; 
	 
      end
    end
    
    %once it finished all possibilities of the one node -- 
    if (a==length(agent1Actions)
      time=
      path(
    end
  end

end