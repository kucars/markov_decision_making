function [dangerZoneReward] = dangerRewardFun(network_indices,dangerLocState,nextLocation)
  dangerZoneReward=-100;
  
  x=power((network_indices(dangerLocState,1)-network_indices(nextLocation,1)),2);
  y=power((network_indices(dangerLocState,2)-network_indices(nextLocation,2)),2);
  distance=sqrt(x+y);
  
  if (distance<=2)
    dangerZoneReward=dangerZoneReward/1;
  elseif (distance<3 && distance>2)
    dangerZoneReward=dangerZoneReward/2;
  elseif(distance<4 && distance>3)
    dangerZoneReward=dangerZoneReward/3;
  elseif(distance>4)
    dangerZoneReward=dangerZoneReward/10;
  end
end%end function 
  
  