function [reward_clearDanger] = clearDangerReward(agent1Actions,agent1Loc,dangerLoc,dangerlocNode,x,a1,network)

reward_clearDanger=0;
	  
if(strcmp(agent1Actions,'clear_danger')&& strcmp(dangerLoc,dangerlocNode)&& strcmp(agent1Loc(network(x,a1)),dangerlocNode))
  reward_clearDanger = 100;   
end
	    
   
end%end function 
  