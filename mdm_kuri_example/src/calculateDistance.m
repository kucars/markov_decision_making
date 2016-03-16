function [distance] = calculateDistance(network_indices,currentLocation,nextLocation)
  distance=0;
  x=power((network_indices(currentLocation,1)-network_indices(nextLocation,1)),2);
  y=power((network_indices(currentLocation,2)-network_indices(nextLocation,2)),2);
  distance=sqrt(x+y)+1;%the +1 because we dont want to have distance =0 
    
end%end function 
  