%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X, agent2 is Y, agent 3 is Z
nodesX            = {'1','2', '3', '4', '5', '6', '7'};
nodesY            = {'1','2', '3', '4', '5', '6', '7'};
nodesZ            = {'1','2', '3', '4', '5', '6', '7'};
victimLoc         = {'6','n'};%n means no victim 
dangerLoc         = {'3', 'n'};%n means no danger
    
%victimLoc         = {'v1','v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10','noVic'};
%dangerLoc         = {'d1','d2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8', 'd9','d10', 'noDan'};

agent1Actions     = {'up','down','right','left','stop','clear_danger'};
agent2Actions     = {'up','down','right','left','stop','clear_danger'};%HendComment: this agent should find_victim 
agent3Actions     = {'up','down','right','left','stop','extract_victim'};

agent1Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};
agent2Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};
agent3Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};

%up,down,right,left,stop,clear/extract
% each node is assigned to be a network. each node is connected to only few nodes according to the map these are the numbers 
% example: network1 of node 1: cant go to up, down and right that why all zero. can go left which is node 2. should stay in node 1 if stop of clear/extract 
%network1 = [0,0,0,2,1,1]; 
%network2 = [3,0,1,0,2,2]; 
%network3 = [4,2,0,6,3,3]; 
%network4 = [0,3,5,0,4,4]; 
%network5 = [0,0,0,4,5,5]; 
%network6 = [0,7,3,0,6,6];
%network7 = [6,0,0,0,7,7];

%networks = {network1 network2 network3 network4 network5 network6 network7};

network =[[0,0,0,2,1,1];[3,0,1,0,2,2];[4,2,0,6,3,3];[0,3,5,0,4,4];[0,0,0,4,5,5];[0,7,3,0,6,6];[6,0,0,0,7,7]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_v12_2.dpomdp';  
fid = fopen(outputFile, 'wb');

% Write to File the top comments and warnings
fprintf(fid,'# This DEC-POMDP Model was generated MATLAB Script');
fprintf(fid,'\n# This script is still experimental and bugs might appear');
fprintf(fid,'\n# Tarek Taha & Hend Al Tair - KUSTAR\n');

fprintf(fid,'\n#The agents.');
fprintf(fid,'\nagents: 3');
fprintf(fid,'\ndiscount: 1.0');
fprintf(fid,'\nvalues: reward');
fprintf(fid,'\nstates:');

for x=1:length(nodesX)
    for y=1:length(nodesY) 
        for z=1:length(nodesZ)
            for w=1:length(victimLoc)
                for k=1:length(dangerLoc)
                    fprintf(fid,' %s_%s_%s_%s_%s',nodesX{x},nodesY{y},nodesZ{z},victimLoc{w},dangerLoc{k});
                end 
            end
        end
    end
end
            
%Examples of this are:
%   start: 0.3 0.1 0.0 0.2 0.5
%   start: first-state
%   start: 5
%   start: uniform
%   start include: first-state third state
%   start include: 1 3
%   start exclude: fifth-state seventh-state

%fprintf(fid,'\nstart:\nuniform');

fprintf(fid,'\nstart include: ');
for w=1:length(victimLoc)
   for k=1:length(dangerLoc)
 
	fprintf(fid,'1_7_5_%s_%s ',victimLoc{w}, dangerLoc{k});
        
   end 
end 
%The actions declarations
% ------------------------
% The  (number/list of) actions for each of the agents on a separate line
%    actions: 
%    [ %d, <list of actions> ] 
%    [ %d, <list of actions> ] 
%    ...
%    [ %d, <list of actions> ] 
fprintf(fid,'\nactions:'); 
fprintf(fid,'\n');
for a1=1:length(agent1Actions)
  fprintf(fid,'%s ',agent1Actions{a1});  
end
fprintf(fid,'\n');
for a2=1:length(agent2Actions)
  fprintf(fid,'%s ',agent2Actions{a2});
end
fprintf(fid,'\n');
for a3=1:length(agent3Actions)
  fprintf(fid,'%s ',agent3Actions{a3});
end

% The (number/list of) observations for each of the agents on a separate line
%    observations: 
%    [ %d, <list of observations> ]
%    [ %d, <list of observations> ]
%    ...
%    [ %d, <list of observations> ]
fprintf(fid,'\nobservations:'); 

fprintf(fid,'\n');
for o1=1:length(agent1Observation)
 fprintf(fid,'%s ',agent1Observation{o1});
end
fprintf(fid,'\n');

for o2=1:length(agent2Observation)
  fprintf(fid,'%s ',agent2Observation{o2}); 
end
fprintf(fid,'\n');

for o3=1:length(agent3Observation)
  fprintf(fid,'%s ',agent3Observation{o3}); 
end

% Transition probabilities
%   T: <a1 a2...an> : <start-state> : <end-state> : %f
% or
%    T: <a1 a2...an> : <start-state> :
%    %f %f ... %f                           P(s_1'|ja,s) ... P(s_k'|ja,s)
% or
%    T: <a1 a2...an> :                      this is a |S| x |S| matrix
%    %f %f ... %f                           P(s_1'|ja,s_1) ... P(s_k'|ja,s_1)
%    %f %f ... %f                           ...
%    ...                                            ...
%    %f %f ... %f                           P(s_1'|ja,s_k) ... P(s_k'|ja,s_k)
% or
%    T: <a1 a2...an> 
%    [ identity, uniform ]
% T: * :
% uniform
% T:open-right open-right :
% uniform
% T: listen listen :
% identity 

% This baiscally means that from any state, you can go to any of the adjacent states
% This has to be improved to limit the Transition between victims and danger, because we assume that they remain in the same location

nxtNodex='';
nxtNodey='';
nxtNodez='';
nxtdangerLoc='';
nxtvictimLoc='';

uniProb1=0;  
uniProb2=0;

%HencComment: remember array start the index from 1 not zero 
%  
nxtNx = [0,0];%HendComment: this array to store in the 0 index the next node with the uncertainty and in the 1 index the next node with uncertainty-1  
nxtNy = zeros(1,2);
nxtNz = zeros;
nxtD= zeros;%HendComment: this is array for the next danger location (with uncertainty and uncertainty-1) 
nxtV= zeros; %HendComment: this is array for the next victim location (with uncertainty and uncertainty-1) 

probx= zeros;%HendComment: this is to save the probabilities (0 index for the uncertainty and 1 index for the uncertainty-1) 
proby= zeros;
probz=zeros;
probd=zeros;%HendComment: this is for the danger probability (uncertainty and uncertainty-1) 
probv= zeros;

%up,down,right,left,stop,clear/extract
%network =[[0,0,0,2,1,1];[3,0,1,0,2,2];[4,2,0,6,3,3];[0,3,5,0,4,4];[0,0,0,4,5,5];[0,7,3,0,6,6];[6,0,0,0,7,7]];
%****************
%****************
%i have put the options function to count the number of options for each node where the next node should be. but there is an extra issue 
% which is the danger and victim.. shouldn't those nodes with these targets should be added as options too next state could be them too! 
% wouldnt be like the  next node (as a state) associated with the next danger or victim states?!?!?
%****************
%****************
uncertainty = 0.9; 
for a1=1:length(agent1Actions)
    for a2=1:length(agent2Actions)
        for a3=1:length(agent3Actions)
            for x=1:length(nodesX)
                for y=1:length(nodesY)
                    for z=1:length(nodesZ)
                         for w=1:length(victimLoc)
                            for k=1:length(dangerLoc) 
                            %===============AGENT X=========================================================================================================
				%----------(1)agent x in node 3 ---------------------------------------------------------------------------------
				if(x==3)
					if(a1==6)%HendComment: action is to clear_danger
					      if(k==1)%HendComment: if there is danger 
						nxtNx(1)= nodesX{x};
						probx(1)=uncertainty;
						nxtD(1)= dangerLoc{2};%HendComment: the danger is cleared 
						probd(1)=uncertainty;
						   
						nxtNx(2)= nodesX{network(x,a1)};
						probx(2)= (1-uncertainty)/(options(x)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger
					      else%HendComment: if there is no danger
						nxtNx(1)=nodesX{x}; 
						probx(1)=uncertainty;
						nxtD(1)= dangerLoc{k};
						probd(1)=uncertainty;
					    
						nxtNx(2)= nodesX{network(x,a1)};
						probx(2)= (1-uncertainty)/(options(x)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options(8)-1); 
					      end
					elseif(a1==5) %HendComment: action is STOP : here it does not matter if if there is danger or not becasue we dont care about the observation. just the action stop
					      nxtNx(1)= nodesX{x};
					      probx(1)=uncertainty;
					      nxtD(1)= dangerLoc{k};
					      probd(1)=uncertainty; 
					   
					      nxtNx(2)= nodesX{network(x,a1)};
					      probx(2)= (1-uncertainty)/(options(x)-1);
					      if (k==1)
						 nxtD(2)=dangerLoc{2};
					      else 
						 nxtD(2)=dangerLoc{1};
					      end 
					      probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a1<5)%HendComment: the four directions 
						if (network(x,a1)~=0)%HendComment: i cannot check if there is danger or not in this case becasue i dont care about the obvservation, we put probability for actions given T(s,a,s') 
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1)= uncertainty;
						    nxtD(1)= dangerLoc{k};
						    probd(1)=uncertainty;
						  
						    nxtNx(2)= nodesX{x};
						    probx(2)= (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger becaue probd is prob of danger  
						else%HendComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						    probx(2) = (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1); 
						end 
					end %HendComment: end the actions within node 3 
				%----------(2)agent x in node 6 where the victim is in--------------------------------------------------------
				%HendQuestion: does it matter if victim exists or not? this robot will locate victim? but what if he does not have the ability to recognize a victim? IN STOP action: actually not because we dont care about observation at this stage 
				%HendQuestion: do we need to put prob of victim or not? 
				elseif(x==6)
					if(a1==6) %HendComment: 6 is clear_danger 
						   nxtNx(1)= nodesX{x};
						   probx(1)=uncertainty;
						   nxtD(1)= dangerLoc{k};
						   probd(1)=uncertainty;
						   
						   nxtNx(2)= nodesX{network(x,a1)};
						   probx(2)= (1-uncertainty)/(options(x)-1);
						   if (k==1)
						    nxtD(2)=dangerLoc{2};
						   else 
						    nxtD(2)=dangerLoc{1};
						   end 
						   probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a1==5)%HendComment: action 5 is STOP 
						   nxtNx(1)= nodesX{x};
						   probx(1)= uncertainty;
						   nxtD(1)= dangerLoc{k};
						   probd(1)=uncertainty;
						   
						   nxtNx(2)= nodesX{network(x,a1)};
						   probx(2)=(1-uncertainty)/(options(x)-1);
						  if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						    nxtD(2)=dangerLoc{2};
						  else 
						    nxtD(2)=dangerLoc{1};
						  end 
						  probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a1<5)%HendComment: these are the four directions
						if(network(x,a1)~=0)
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1)= uncertainty;
						    nxtD(1)= dangerLoc{k};
						    probd(1)=uncertainty;
						  
						    nxtNx(2)= nodesX{x};
						    probx(2)= (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger becaue probd is prob of danger  
					      else%HendComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						    probx(2) = (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);
					      end
									
					end %end if action x in node 6
				%----------(3)agent x in any other node than 3 and 6 -----------------------------------------------------------------
				else
					if(a1==6) %HendComment: 6 is clear_danger 
						nxtNx(1)= nodesX{x};
						probx(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					        
					        nxtNx(2)= nodesX{network(x,a1)};
					        probx(2) = (1-uncertainty)/(options(x)-1);%HendComment: the options(x)-1 will return the number of options starting from this node. and the -1 is including stay in the same node 
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a1==5)%HendComment: action 5 is STOP 
						nxtNx(1)= nodesX{x};
						probx(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					        
					        nxtNx(2)=  nodesX{network(x,a1)};
					        probx(2) = (1-uncertainty)/(options(x)-1);
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options(8)-1);
					elseif(a1<5)%HendComment: these are the four directions
						if(network(x,a1)~=0)
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{x};
						    probx(2) = (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);
						else%HencComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
						   
						   %nodesX{network(x,a1)+1}
						    
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						   
						    probx(2) = (1-uncertainty)/(options(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);
						end				
					end %end if actionx for any other node (not 3 or 6)
				end %end if node x 
                            %===============AGENT Y=========================================================================================================
			      %----------(1)agent y in node 3 ------------------
				if(y==3)
					if(a2==6)%HendComment: action is to clear_danger
					    if(k==1)%HendComment: if there is danger 
						nxtNy(1)= nodesY{y};
						proby(1)=uncertainty;
						nxtD(1)= dangerLoc{2};%HendComment: the danger is cleared 
						probd(1)=uncertainty;
						   
						nxtNy(2)= nodesY{network(y,a2)};
						proby(2)= (1-uncertainty)/(options(y)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger
					    else%HendComment: if there is no danger
						nxtNy(1)=nodesY{y}; 
						proby(1)=uncertainty;
						nxtD(1)= dangerLoc{k};
						probd(1)=uncertainty;
					    
						nxtNy(2)= nodesY{network(y,a2)};
						proby(2)= (1-uncertainty)/(options(y)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options(8)-1); 
					    end
					elseif(a2==5) %HendComment: action is STOP : here it does not matter if if there is danger or not becasue we dont care about the observation. just the action stop
						nxtNy(1)= nodesY{y};
						proby(1)=uncertainty;
						nxtD(1)= dangerLoc{k};
						probd(1)=uncertainty; 
					   
						nxtNy(2)= nodesY{network(y,a2)};
						proby(2)= (1-uncertainty)/(options(y)-1);
						if (k==1)
						    nxtD(2)=dangerLoc{2};
						else 
						    nxtD(2)=dangerLoc{1};
						end 
						probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a2<5)%HendComment: the four directions 
						if (network(y,a2)~=0)%HendComment: i cannot check if there is danger or not in this case becasue i dont care about the obvservation, we put probability for actions given T(s,a,s') 
						    nxtNy(1)= nodesY{network(y,a2)};
						    proby(1)= uncertainty;
						    nxtD(1)= dangerLoc{k};
						    probd(1)=uncertainty;
						  
						    nxtNy(2)= nodesY{y};
						    proby(2)= (1-uncertainty)/(options(y)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger becaue probd is prob of danger  
						else%HendComment: (network(x,a1)==0)
						    nxtNy(1)= nodesY{y};
						    proby(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNy(2)=  nodesY{network(y,a2)+1};
						    proby(2) = (1-uncertainty)/(options(y)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options(8)-1); 
						end 
					  end %HendComment: end the actions within node 3 
				%----------(2)agent y in node 6 ------------------------------------------------------------------------------------------------
				elseif(y==6)
					if(a2==6) %HendComment: 6 is clear_danger 
						nxtNy(1)= nodesY{y};
						proby(1)=uncertainty;
						nxtD(1)= dangerLoc{k};
						probd(1)=uncertainty;
						   
						   nxtNy(2)= nodesY{network(y,a2)};
						   proby(2)= (1-uncertainty)/(options(y)-1);
						   if (k==1)
						    nxtD(2)=dangerLoc{2};
						   else 
						    nxtD(2)=dangerLoc{1};
						   end 
						   probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a2==5)%HendComment: action 5 is STOP 
						   nxtNy(1)= nodesY{y};
						   proby(1)= uncertainty;
						   nxtD(1)= dangerLoc{k};
						   probd(1)=uncertainty;
						   
						   nxtNy(2)= nodesY{network(y,a2)};
						   proby(2)=(1-uncertainty)/(options(y)-1);
						  if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						    nxtD(2)=dangerLoc{2};
						  else 
						    nxtD(2)=dangerLoc{1};
						  end 
						  probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a2<5)%HendComment: these are the four directions
						  if(network(y,a2)~=0)
						      nxtNy(1)= nodesY{network(y,a2)};
						      proby(1)= uncertainty;
						      nxtD(1)= dangerLoc{k};
						      probd(1)=uncertainty;
						  
						      nxtNy(2)= nodesY{y};
						      proby(2)= (1-uncertainty)/(options(y)-1);
						      if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtD(2)=dangerLoc{2};
						      else 
							nxtD(2)=dangerLoc{1};
						      end 
						      probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger becaue probd is prob of danger   						
						  else%HendComment: (network(x,a1)==0)
						      nxtNy(1)= nodesY{y};
						      proby(1) =uncertainty;
						      nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probd(1)=uncertainty;%HendComment:the danger
					        
						      nxtNy(2)=  nodesY{network(y,a2)+1};
						      proby(2) = (1-uncertainty)/(options(y)-1);
						      if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtD(2)=dangerLoc{2};
						      else 
							nxtD(2)=dangerLoc{1};
						      end 
						      probd(2)=(1-uncertainty)/(options(8)-1);
						  end
									
					end %end if action x in node 6
				%----------(3)agent y in any node -----------------------------------------------------------------------------------------------------------
				else
					if(a2==6) %HendComment: 6 is clear_danger 
						nxtNy(1)= nodesY{y};
						proby(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					        
					        nxtNy(2)= nodesY{network(y,a2)};
					        proby(2) = (1-uncertainty)/(options(y)-1);%HendComment: the options(x)-1 will return the number of options starting from this node. and the -1 is including stay in the same node 
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options(8)-1);%HendComment: the options(8) are the options of the danger 
					elseif(a2==5)%HendComment: action 5 is STOP 
						nxtNy(1)= nodesY{y};
						proby(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					       
					       nxtNy(2)=  nodesY{network(y,a2)};
					        proby(2) = (1-uncertainty)/(options(y)-1);
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options(8)-1);
					elseif(a2<5)%HendComment: these are the four directions
						if(network(y,a2)~=0)
						      nxtNy(1)= nodesY{network(y,a2)};
						      proby(1) =uncertainty;
						      nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probd(1)=uncertainty;%HendComment:the danger
					        
						      nxtNy(2)=  nodesY{y};
						      proby(2) = (1-uncertainty)/(options(y)-1);
						      if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtD(2)=dangerLoc{2};
						      else 
							nxtD(2)=dangerLoc{1};
						      end 
						      probd(2)=(1-uncertainty)/(options(8)-1);
						else%HencComment: (network(x,a1)==0)
						      nxtNy(1)= nodesY{y};
						      proby(1) =uncertainty;
						      nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probd(1)=uncertainty;%HendComment:the danger
					        
						      nxtNy(2)=  nodesY{network(y,a2)+1};
						      proby(2) = (1-uncertainty)/(options(y)-1);
						      if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtD(2)=dangerLoc{2};
						      else 
							nxtD(2)=dangerLoc{1};
						      end 
						      probd(2)=(1-uncertainty)/(options(8)-1);
						end				
					end %end if actionx for any other node (not 3 or 6)
				end %end if node x 
                            %===============AGENT Z=========================================================================================================
				%----------(1)agent z in node 3 ---------------------------------------------------------------
				if(z==3)
					if(a3==6)%HendComment: the action is to extract_victim while it is in the node of danger 
					      nxtNz(1)=nodesZ{z};
					      probz(1)=uncertainty;
					      nxtV(1)= victimLoc{w};
					      probv(1)=uncertainty;
					      
					      nxtNz(2)=nodesZ{network(z,a3)};
					      probz(2)=(1-uncertainty)/(options(z)-1);
					      nxtV(2)= victimLoc{w};
					      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						   nxtV(2)=victimLoc{2};
					      else 
						   nxtV(2)=victimLoc{1};
					      end 
					      probv(2)=(1-uncertainty)/(options(z)-1);
					elseif(a3==5) %HendComment: the action is stop------ same as action exttract victim in this case 
					      nxtNz(1)=nodesZ{z};
					      probz(1)=uncertainty;
					      nxtV(1)= victimLoc{w};
					      probv(1)=uncertainty;
					      
					      nxtNz(2)=nodesZ{network(z,a3)};
					      probz(2)=(1-uncertainty)/(options(z)-1);
					      nxtV(2)= victimLoc{w};
					      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						   nxtV(2)=victimLoc{2};
					      else 
						   nxtV(2)=victimLoc{1};
					      end 
					      probv(2)=(1-uncertainty)/(options(z)-1);
					elseif(a3<5)
						if(network(z,a3)~=0)
						      nxtNz(1)= nodesZ{network(z,a3)};
						      probz(1) =uncertainty;
						      nxtV(1)= victimLoc{w};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probv(1)=uncertainty;%HendComment:the danger
					        
						      nxtNz(2)=  nodesZ{z};
						      probz(2) = (1-uncertainty)/(options(z)-1);
						      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtV(2)=victimLoc{2};
						      else 
							nxtV(2)=victimLoc{1};
						      end 
						      probv(2)=(1-uncertainty)/(options(9)-1);
						else%HencComment: (network(z,a3)==0)
						      nxtNz(1)= nodesZ{z};
						      probz(1) =uncertainty;
						      nxtV(1)= victimLoc{w};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probv(1)=uncertainty;%HendComment:the danger
					        
						      nxtNz(2)=  nodesZ{network(z,a3)+1};
						      probz(2) = (1-uncertainty)/(options(z)-1);
						      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtV(2)=victimLoc{2};
						      else 
							nxtV(2)=victimLoc{1};
						      end 
						      probv(2)=(1-uncertainty)/(options(9)-1);
						end								
					end %end if action  z for node 3 
				%----------(2)agent z in node 6 where there is a victim ----------------------------------------------------------------
				elseif(z==6)
					if(a3==6)%HendComment: action is to extract_victim
						if(w==1)%HendComment: means that victim exists 
                                                  nxtNz(1)=nodesZ{z}; 
                                                  probz(1)= uncertainty;
                                                  nxtV(1)= victimLoc{2};
                                                  probv(1)=uncertainty;
                                                  
                                                  nxtNz(2)=nodesZ{network(z,a3)}; 
                                                  probz(2)= (1-uncertainty)/(options(z)-1);
                                                  nxtV(1)= victimLoc{1};
                                                  probv(2)=(1-uncertainty)/(options(9)-1);
                                    		else %HendComment: if victim does not exist
                                    		  nxtNz(1)=nodesZ{z}; 
                                    		  probz(1)= uncertainty;
                                                  nxtV(1)= victimLoc{w};
                                                  probv(1)=uncertainty;
                                    		  
                                    		  nxtNz(2)= nodesZ{network(z,a3)+1}; 
                                                  probz(2)= (1-uncertainty)/(options(z)-1);
						  nxtV(1)= victimLoc{1};
                                                  probv(2)=(1-uncertainty)/(options(9)-1);
						end 
					elseif(a3==5)%HendComment: action is stop 
						nxtNz(1)= nodesZ{z};
						probz(1)=uncertainty;
						nxtV(1)= victimLoc{w};
						probv(1)=uncertainty; 
					   
						nxtNz(2)= nodesZ{network(z,a3)};
						probz(2)= (1-uncertainty)/(options(z)-1);
						if (w==1)
						  nxtV(2)=victimLoc{2};
						else 
						  nxtV(2)=victimLoc{1};
						end 
						probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the danger 
					elseif(a3<5)%HendComment: action is one of the 4 directions 
						if(network(z,a3)~=0)
						    nxtNz(1)= nodesZ{network(z,a3)};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the victim 
						else %HendComment: (network(z,a3)==0))
						    nxtNz(1)= nodesZ{z};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the victim 
						end
					end %end if actionz for node 6
				%----------(3)agent z in any node ----------------------------------------------------------------------
				else%HendComment: z any node than 3 and 6
					if(a3==6)%Hendcomment: 6 is the extrac victim action 
					    nxtNz(1)=nodesZ{z};
					    probz(1)=uncertainty;
					    nxtV(1)= victimLoc{w};
					    probv(1)=uncertainty;
					
					    nxtNz(2)=nodesZ{network(z,a3)};
					    probz(2)= (1-uncertainty)/(options(z)-1);
					    if (w==1)
						  nxtV(2)=victimLoc{2};
					    else 
						  nxtV(2)=victimLoc{1};
					    end 
					    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the victim 
					elseif(a3==5) %HendComment: 5 is the stop action
					    nxtNz(1)= nodesZ{z};
					    probz(1)=uncertainty;
					    nxtV(1)= victimLoc{w};
					    probv(1)=uncertainty; 
					   
					    nxtNz(2)= nodesZ{network(z,a3)};
					    probz(2)= (1-uncertainty)/(options(z)-1);
					    if (w==1)
					      nxtV(2)=victimLoc{2};
					    else 
					      nxtV(2)=victimLoc{1};
					    end 
					    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the danger 
					elseif(a3<5)
						if(network(z,a3)~=0)
						    nxtNz(1)= nodesZ{network(z,a3)};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the victim 
						else %HendComment: (network(z,a3)==0))
						    nxtNz(1)= nodesZ{z};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options(9)-1);%HendComment: the options(9) are the options of the victim 
						end
					end %end if action z for any other node (not 3 or 6)
				end %end if node z                   
				%==========================================Print the probability=====================================
                                   
				uniProb1= probx(1)*proby(1)*probz(1)*probd(1)*probv(1);
				uniProb2= probx(2)*proby(2)*probz(2)*probd(2)*probv(2);

                                fprintf(fid,'\nT: %s %s %s : %s_%s_%s_%s_%s : %s_%s_%s_%s_%s :  %f',agent1Actions{a1},agent2Actions{a2},agent3Actions{a3},nodesX{x},nodesY{y},nodesZ{z},victimLoc{w},dangerLoc{k},nxtNx(1),nxtNy(1),nxtNz(1),nxtV(1),nxtD(1),uniProb1);                                               
                                fprintf(fid,'\nT: %s %s %s : %s_%s_%s_%s_%s : %s_%s_%s_%s_%s :  %f',agent1Actions{a1},agent2Actions{a2},agent3Actions{a3},nodesX{x},nodesY{y},nodesZ{z},victimLoc{w},dangerLoc{k},nxtNx(2),nxtNy(2),nxtNz(2),nxtV(2),nxtD(2),uniProb2);                                               
   
                            end
                         end
                    end
                end
            end
        end
    end
end
% Observation probabilities
%     O: <a1 a2...an> : <end-state> : <o1 o2 ... om> : %f
% or
%     O: <a1 a2...an> : <end-state> :
%     %f %f ... %f	    P(jo_1|ja,s') ... P(jo_x|ja,s')
% or
%     O:<a1 a2...an> :	    - a |S|x|JO| matrix
%     %f %f ... %f	    P(jo_1|ja,s_1') ... P(jo_x|ja,s_1') 
%     %f %f ... %f	    ... 
%     ...		    ...
%     %f %f ... %f	    P(jo_1|ja,s_k') ... P(jo_x|ja,s_k') 
%O: * : uniform

%O: * : f0_f0_f0_h1_h1 : flames flames : 0.04
%O: * : f0_f0_f0_h1_h1 : flames noFlames : 0.16
%O: * : f0_f0_f0_h1_h1 : noFlames flames : 0.16
%O: * : f0_f0_f0_h1_h1 : noFlames noFlames : 0.64

% Add uniformity just in case we missed something
%fprintf(fid,'\nO: * :\nuniform');
            for x=1:length(nodesX)
                for xx=1:length(nodesY)
                    for xxx=1:length(nodesZ)
                      for w=1:length(victimLoc)
                        for k=1:length(dangerLoc)
                          %for o1=1:length(agent1Observation)
                           % for o2=1:length(agent2Observation) 
                            %   for o3=1:length(agent3Observation) 
                               obsXPro = 0;
                               obsYPro = 0;
                               obsZPro = 0;
                               obs1String = '';
                               %==========================Observation agent1 ==============================
                               if(strcmp( nodesX{x}, '6')   && strcmp(victimLoc{w},'6'))
                                   obs1String = 'vic';
                               else 
                                   obs1String = 'noVic';
                               end
                               if(strcmp( nodesX{x}, '3')   && strcmp(dangerLoc{k},'3'))
                                   obs1String = strcat(obs1String,'_dan');
                               else 
                                   obs1String = strcat(obs1String,'_noDan');
                               end
                               %========================Observation agent2 ==================================
                               if(strcmp( nodesY{xx}, '6')   && strcmp(victimLoc{w},'6'))
                                   obs2String = 'vic';
                               else 
                                   obs2String = 'noVic';
                               end
                               if(strcmp( nodesY{xx}, '3')  && strcmp(dangerLoc{k},'3'))
                                   obs2String = strcat(obs2String,'_dan');
                               else 
                                   obs2String = strcat(obs2String,'_noDan');
                               end     
                               %=======================Observation agent3 ===================================
                               if(strcmp( nodesZ{xxx}, '6')   && strcmp(victimLoc{w},'6'))
                                   obs3String = 'vic';
                               else 
                                   obs3String = 'noVic';
                               end
                               if(strcmp( nodesZ{xxx}, '3')  && strcmp(dangerLoc{k},'3'))
                                   obs3String = strcat(obs3String,'_dan');
                               else 
                                   obs3String = strcat(obs3String,'_noDan');
                               end
                               
                               fprintf(fid,'\nO: * : %s_%s_%s_%s_%s :  %s %s %s :%f',nodesX{x},nodesY{xx},nodesZ{xxx},victimLoc{w},dangerLoc{k},obs1String,obs2String,obs3String,0.9);
                            %end
                         %end
                       %end
		      end
		    end
                  end 
                end
            end
 
% Build Reward Function
% Typical problems only use R(s,ja) which is specified by:
%   R: <a1 a2...an> : <start-state> : * : * : %f
%   or
%   R: <a1 a2...an> : <start-state> : <end-state> : <observation> %f

%---------------- Useless motions are penalised----------------------------
%fprintf(fid,'\nR: * : * : * : * : -1.0');
fprintf(fid,'\nR: * : * : * : * : -1.00');

%---------------- Seeing a danger or victim is rewarded--------------------
% human only see victim OR no victim no danger  

%  for o1=1:length(agent1Observation)
%      for o2=1:length(agent2Observation)
%          if(strcmp(agent1Observation{o1},'noVic_noDan') && strcmp(agent2Observation{o2},'noVic_noDan'))
%             fprintf(fid,'\nR: * : * : * : %s %s noVic_noDan : -1',agent1Observation{o1}, agent2Observation{o2}); % it is just another movement 
%          else
%              fprintf(fid,'\nR: * : * : * : %s %s noVic_noDan : 50',agent1Observation{o1}, agent2Observation{o2});
%          end
%          fprintf(fid,'\nR: * : * : * : %s %s vic_noDan : 50',agent1Observation{o1}, agent2Observation{o2});
%      end 
%  end
%fprintf(fid,'\nR: * : * : * : vic_dan : 50');
%fprintf(fid,'\nR: * : * : * : vic_noDan : 50');
%fprintf(fid,'\nR: * : * : * : noVic_dan : 50');
%----------------- penality for human go to danger------------------------- 
%   for x=1:length(nodesX)
%       for xx=1:length(nodesY)
%            for xxx=1:length(victimLoc)
%                  fprintf(fid,'\nR:  * : * :  %s_%s_n3_%s_d3 :  * : -50', nodesX{x}, nodesY{xx}, victimLoc{xxx});
%            end
%       end 
%   end
 
%--------------- HUman stop when node 3 has danger --------------------
%should stop near by node 3 in the start node 

for a1=1:length(agent1Actions)
    for a2=1:length(agent2Actions)
	for x=1:length(nodesX)
	    for xx=1:length(nodesY)
		for xxx=1:length(nodesZ)
		     if (strcmp(nodesX{x},'3') || strcmp(nodesY{xx},'3'))
			if ( strcmp(nodesZ{xxx},'1') ||  strcmp(nodesZ{xxx},'2') || strcmp(nodesZ{xxx},'4') ||  strcmp(nodesZ{xxx},'5') || strcmp(nodesZ{xxx},'6') ||  strcmp(nodesZ{xxx},'7'))
			      if( strcmp(agent1Actions{a1},'clear_danger') || strcmp(agent2Actions{a2},'clear_danger'))
				  fprintf(fid,'\nR:  %s %s stop: %s_%s_%s_6_3 : * : * : 50', agent1Actions{a1},agent2Actions{a2},nodesX{x},nodesY{xx}, nodesZ{xxx});
				  fprintf(fid,'\nR:  %s %s stop: %s_%s_%s_noVic_3 : * : * : 50', agent1Actions{a1},agent2Actions{a2},nodesX{x},nodesY{xx}, nodesZ{xxx});
			      end
			end
		     end
		end 
	    end
	end 
    end
end 

% -----------------Reward for clearing danger----------------------------------

%   for x=1:length(nodesX)
%       for xx=1:length(nodesY)
%         for xxx=1:length(nodesZ)
%            for xxxx=1:length(victimLoc) 
%              for i2=1:length(nodesX)
%                for ii2=1:length(nodesY)
%                 for iii2=1:length(nodesZ)
%                  for iiii2=1:length(victimLoc)                  
%                      fprintf(fid,'\nR:  * : %s_%s_%s_%s_d3 :  %s_%s_%s_%s_noDan : * : 50', nodesX{x}, nodesY{xx}, nodesZ{xxx}, victimLoc{xxxx}, nodesX{i2}, nodesY{ii2}, nodesZ{iii2}, victimLoc{iiii2});
%                  end
%                end
%              end
%            end
%          end
%         end
%       end 
%   end

 
%--------------- Extracting a victim is highly rewarded--------------------
for x=1:length(nodesX)
  for y=1:length(nodesY)
    for a1=1:length(agent1Actions)
      for a2=1:length(agent2Actions)
	for k=1:length(dangerLoc)
	  fprintf(fid,'\nR:  %s %s extract_victim: %s_%s_6_6_%s : * : * : 100', agent1Actions{a1},agent2Actions{a2},nodesX{x},nodesY{y},dangerLoc{k});
	end
      end
    end
  end
end 


%  fprintf(fid,'\nR:  clear_danger clear_danger extract_victim: * : * : * : 100');
%  fprintf(fid,'\nR:  clear_danger up extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  clear_danger down extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  clear_danger left extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  clear_danger right extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  clear_danger stop extract_victim:    * : * : * : 100');
%  
%  fprintf(fid,'\nR:  up clear_danger extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  down clear_danger extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  left clear_danger extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  right clear_danger extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  stop clear_danger extract_victim:    * : * : * : 100');
%  
%  fprintf(fid,'\nR:  up up extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  down down extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  left left extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  right right extract_victim:    * : * : * : 100');
%  fprintf(fid,'\nR:  stop stop extract_victim:    * : * : * : 100');



fprintf(fid,'\n');

fclose(fid);
