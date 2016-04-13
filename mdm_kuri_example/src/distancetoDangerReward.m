function [dangerZoneReward] = distancetoDangerReward(dangerLoc,network,dangerlocNode,network_indices,dangerLocState,z,a2)

dangerZoneReward=0;

dangerPenalization=-50;
if (strcmp(dangerLoc,dangerlocNode))
    distance = calculateDistance(network_indices,dangerLocState,network(z,a2));
    dangerZoneReward= dangerPenalization/distance; 
end 

   
end%end function 
  