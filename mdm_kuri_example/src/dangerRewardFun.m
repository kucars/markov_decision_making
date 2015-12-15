function [dangerZoneReward] = dangerRewardFun(network,dangerLocState,currentLocation)
  dangerZoneReward=-100;
  
  for x=1:4	%we don't need to be 6, only the connected nodes to the 4 directions 
    level1node=network(dangerLocState,x);
    if (currentLocation==level1node)%this is will be high penalization  
	  dangerZoneReward=dangerZoneReward/1;
	  break;
    else
	for i=1:4
	  level2node=network(level1node,i);
	  if(currentLocation==level2node)
	    dangerZoneReward=dangerZoneReward/2;
	    break;
	  else
	    for c=1:4
	      level3node=network(level2node,c);
	      if(currentLocation==level3node)
		dangerZoneReward=dangerZoneReward/3;
		break;
	      else
		for q=1:4
		  level4node=network(level3node,q);
		  if(currentLocation==level4node)
		    dangerZoneReward=dangerZoneReward/10;
		    break;
		  end% end if level 4
		end%end for level 4
	      end%end if level 3
	    end%end for level 3
	  end% end if level 2 danger 
	end%end for level 2 
    end%end if 
  end%end for 
  
end%end function 
  
  