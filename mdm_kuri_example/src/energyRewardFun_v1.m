function [rewardedDistance] = energyRewardFun(network,network_indices,network_steps,currentLocation,nextLocation)
  rewardedDistance=0;
  %--first i calculate the distance between the current loc and the next loc
   x=power((network_indices(currentLocation,1)-network_indices(nextLocation,1)),2);
   y=power((network_indices(currentLocation,2)-network_indices(nextLocation,2)),2);
   distance=sqrt(x+y);
   
   %--second i count the number of steps (for multiple paths) we only have goal is victim. this is path planning 
   
  

  rewardedDistance= distance * steps; 
  
end
