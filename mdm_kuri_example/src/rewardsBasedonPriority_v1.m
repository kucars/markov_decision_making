
function [priority_weights] = rewardsBasedonPriority_v1(priority_order)

%-----------------------set the weights- flexible size---------------------
max_weights = 100; 
for x=1:length(priority_order)
  if (x==1)
    priority_weights (x) = max_weights;
  elseif ((x<= length(priority_order)/2) && (x>1))
    priority_weights (x) = max_weights - (max_weights*0.1);
  elseif(x==length(priority_order))
    priority_weights (x)=-2;
  else
    priority_weights (x) = (max_weights*0.5)-max_weights;
  end %end if
end %end for loop
 


end%end function 
  