function [reward_extractVictim] = extractVictimReward(agent2Actions,agent2Loc,victimLoc,victimlocNode,network,z,a2)

reward_extractVictim=0;

if (strcmp(agent2Actions,'extract_victim')&& strcmp(victimLoc,victimlocNode)&& strcmp(agent2Loc(network(z,a2)),victimlocNode))
  reward_extractVictim = 100; 
end

end%end function 
  