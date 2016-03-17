function [] = rewardsBasedonPriority_v1(priority_order)

%----set the weights- flexible size-----------
max_min_weights = {100,-2}; 
for x=1:length(priority_order)
  if (x==1)
    priority_weights (x) = max_min_weights{1};
  elseif (x==length(priority_order))
    priority_weights (x) = max_min_weights{2};
  elseif (x!=1 && x!=length(priority_order))
    priority_weights (x) = max_min_weights{1}/(x*-1);
  end%end if
end%end for loop
 
%----call the functions based on the priority of objectives--------
for y=1:length(priority_order)
  if(strcmp(priority_order{y},'clear_danger'))
   
   priority_weights(y)
    
  elseif(strcmp(priority_order{y},'dangerDistance'))
    
  elseif(strcmp(priority_order{y},'extract_victim'))
    
  elseif(strcmp(priority_order{y},'time'))
    
  end
end%end for loop


end%end function 
  