function[time]=calculateDistace(network_indices,currentLocation,nextLocation)

  x=(network_indices(currentLocation,1)-network_indices(nextLocation,1));
  y=(network_indices(currentLocation,2)-network_indices(nextLocation,2));
  
  time=x+y;
end