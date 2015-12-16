function [rewardedDistance] = energyRewardFun(network_indices,currentLocation,nextLocation)
  rewardedDistance=-10;
  %--first i calculate the distance between the current loc and the next loc
   x=power((network_indices(currentLocation,1)-network_indices(nextLocation,1)),2);
   y=power((network_indices(currentLocation,2)-network_indices(nextLocation,2)),2);
   distance=sqrt(x+y)+1;
   


  rewardedDistance= rewardedDistance*distance; 
  
end
