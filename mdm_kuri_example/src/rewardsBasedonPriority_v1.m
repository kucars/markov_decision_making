function [priority_weights] = rewardsBasedonPriority_v1(priority_order)

%-----------------------set the weights- flexible size--------------------------------
max_min_weights = {100,-1}; 
for x=1:length(priority_order)
  if (x==1)
    priority_weights (x) = max_min_weights{1};
  elseif (x==length(priority_order))
    priority_weights (x) = max_min_weights{2};
  elseif (x!=1 && x!=length(priority_order))
    priority_weights (x) = max_min_weights{1}/(x*-2);
  end%end if
end%end for loop
 


end%end function 
  