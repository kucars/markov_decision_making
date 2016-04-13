function [jointDistanceReward] = timeReward(network_indices,network,x,z,a1,a2)

jointDistanceReward=0;

uselessMotionPenalization = -2; 
distanceAgent1 = calculateDistance(network_indices,x,network(x,a1));
distanceAgent2 = calculateDistance(network_indices,z,network(z,a2));
jointDistanceReward= (uselessMotionPenalization/distanceAgent1)+(uselessMotionPenalization/distanceAgent2);

   
end%end function 
  