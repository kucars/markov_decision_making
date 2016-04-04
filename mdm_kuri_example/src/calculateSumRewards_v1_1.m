function [sum] = calculateSumRewards_v1_1(priority_order,jointDistanceReward,dangerZoneReward,reward_clearDanger,reward_extractVictim)

sum = 0; 
weightClearDanger = 0;
weightExtractVictim = 0;
weightDangerToDistance =0;
weightTime =0; 

  for x=1:length(priority_order)
    if(strcmp(priority_order{x},'clear_danger'))
      if(x==1)
	weightClearDanger=x;
      elseif ((x>1)&&(x<=length(priority_order)/2))
	weightClearDanger=(x*0.9)/x;
      elseif (x>length(priority_order)/2)
	weightClearDanger=x/10; 
      end 
    elseif(strcmp(priority_order{x},'dangerDistance'))
      if(x==1)
	weightDangerToDistance=x;
      elseif ((x>1)&&(x<=length(priority_order)/2))
	weightDangerToDistance=(x*0.9)/x;
      elseif (x>length(priority_order)/2)
	weightDangerToDistance=x/15;
      end  
    elseif(strcmp(priority_order{x},'extract_victim'))
      if(x==1)
	weightExtractVictim=x;
      elseif ((x>1)&&(x<=length(priority_order)/2))
	weightExtractVictim=(x*0.9)/x;
      elseif (x>length(priority_order)/2)
	weightExtractVictim=x/10;
      end  
    elseif(strcmp(priority_order{x},'time'))
      if(x==1)
	weightTime=x;
      elseif ((x>1)&&(x<=length(priority_order)/2))
	weightTime=(x*0.9)/x;
      elseif (x>length(priority_order)/2)
	weightTime=x/10;
      end  
    end%end for loop
  end%end for loop 

  sum = (reward_clearDanger*weightClearDanger)+(reward_extractVictim*weightExtractVictim)+(dangerZoneReward*weightDangerToDistance)+(jointDistanceReward*weightTime);
end %end function 