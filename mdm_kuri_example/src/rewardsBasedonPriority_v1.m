
function [priority_weights] = rewardsBasedonPriority_v1(priority_order)

%-----------------------set the weights- flexible size---------------------
max_weights = 100; 
for x=1:length(priority_order)
  if (x==1)
    priority_weights (x) = max_weights;
  elseif ((x<= length(priority_order)/2) && (x>1))
    priority_weights (x) = max_weights-(x*8);
  else
    priority_weights (x) = (x*x*6)-max_weights;
  end %end if
end %end for loop
 


end%end function 
  