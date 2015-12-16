function [dangerZoneReward] = dangerRewardFun(network_indices,dangerLocState,nextLocation)
  dangerZoneReward=-100;
  
  x=power((network_indices(dangerLocState,1)-network_indices(nextLocation,1)),2);
  y=power((network_indices(dangerLocState,2)-network_indices(nextLocation,2)),2);
  distance=sqrt(x+y)+1;
  
  dangerZoneReward=dangerZoneReward/distance;
  
end%end function 
  
  