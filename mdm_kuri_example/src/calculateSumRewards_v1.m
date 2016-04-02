function [sum] = calculateSumRewards_v1(priority_order,jointDistanceReward,dangerZoneReward,reward_clearDanger,reward_extractVictim)

sum = 0; 
weightClearDanger = 0;
weightExtractVictim = 0;
weightDangerToDistance =0;
weightTime =0; 

  for x=1:length(priority_order)
    if(strcmp(priority_order{x},'clear_danger'))
      if(x==1)
	weightClearDanger
      elseif (x>1)
	weightClearDanger
      end 
    elseif if(strcmp(priority_order{x},'dangerDistance'))
      if(x==1)
	weightDangerToDistance
      elseif (x>1)
	weightDangerToDistance
      end  
    elseif (strcmp(priority_order{y},'extract_victim'))
      if(x==1)
	weightExtractVictim
      elseif (x>1)
	weightExtractVictim
      end  
    elseif(strcmp(priority_order{y},'time'))
      if(x==1)
	weightTime
      elseif (x>1)
	weightTime
      end  
    end%end for loop
  end%end for loop 

  sum = (reward_clearDanger*weightClearDanger)+(reward_extractVictim*weightExtractVictim)+(dangerZoneReward*weightDangerToDistance)+(jointDistanceReward*weightTime);
end %end function 