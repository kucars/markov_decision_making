%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X,  agent 2 is Z
nodesX            = {'a','b','c'};
nodesZ            = {'a','b','c'};
victimLoc         = {'a','n'};%n means no victim 
dangerLoc         = {'b','n'};%n means no danger

agent1Actions     = {'right','left','stop','clear_danger'};
agent3Actions     = {'right','left','stop','extract_victim'};

%  agent1Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};
%  agent3Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};

agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
agent3Observation = {'vic_noDan','noVic_dan','noVic_noDan'};


%right,left,stop,clear/extract

network =[[2,0,1,1];[3,1,2,2];[0,2,3,3]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_1x3_v1_5.dpomdp';  
fid = fopen(outputFile, 'wb');

% Write to File the top comments and warnings
fprintf(fid,'# This DEC-POMDP Model was generated MATLAB Script');
fprintf(fid,'\n# This script is still experimental and bugs might appear');
fprintf(fid,'\n# Tarek Taha & Hend Al Tair - KUSTAR\n');

fprintf(fid,'#The agents.');
fprintf(fid,'\nagents: 2');
fprintf(fid,'\ndiscount: 1.0');
fprintf(fid,'\nvalues: reward');
fprintf(fid,'\nstates:');

for x=1:length(nodesX)
        for z=1:length(nodesZ)
            for w=1:length(victimLoc)
                for k=1:length(dangerLoc)
                    fprintf(fid,'%s_%s_%s_%s ',nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k});
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

fprintf(fid,'\nstart:\nuniform');

%  fprintf(fid,'\nstart include: ');
%  for w=1:length(victimLoc)
%     for k=1:length(dangerLoc)
%   
%  	fprintf(fid,'1_7_5_%s_%s ',victimLoc{w}, dangerLoc{k});
%          
%     end 
%  end 
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
%i have put the options_1x3 function to count the number of options_1x3 for each node where the next node should be. but there is an extra issue 
% which is the danger and victim.. shouldn't those nodes with these targets should be added as options_1x3 too next state could be them too! 
% wouldnt be like the  next node (as a state) associated with the next danger or victim states?!?!?
%****************
%****************
uncertainty = 0.9; 
for a1=1:length(agent1Actions)
        for a3=1:length(agent3Actions)
            for x=1:length(nodesX)
                    for z=1:length(nodesZ)
                         for w=1:length(victimLoc)
                            for k=1:length(dangerLoc) 
                            %===============AGENT X=========================================================================================================
				%----------(1)agent x in node 3 ---------------------------------------------------------------------------------
				if(x==2)
					if(a1==4)%HendComment: action is to clear_danger
					      if(k==1)%HendComment: if there is danger 
						nxtNx(1)= nodesX{x};
						probx(1)=uncertainty;
						nxtD(1)= dangerLoc{2};%HendComment: the danger is cleared 
						probd(1)=uncertainty;
						   
						nxtNx(2)= nodesX{network(x,a1)};
						probx(2)= (1-uncertainty)/(options_1x3(x)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger
					      else%HendComment: if there is no danger
						nxtNx(1)=nodesX{x}; 
						probx(1)=uncertainty;
						nxtD(1)= dangerLoc{k};
						probd(1)=uncertainty;
					    
						nxtNx(2)= nodesX{network(x,a1)};
						probx(2)= (1-uncertainty)/(options_1x3(x)-1);
						nxtD(2)=dangerLoc{1};
						probd(2)=(1-uncertainty)/(options_1x3(8)-1); 
					      end
					elseif(a1==3) %HendComment: action is STOP : here it does not matter if if there is danger or not becasue we dont care about the observation. just the action stop
					      nxtNx(1)= nodesX{x};
					      probx(1)=uncertainty;
					      nxtD(1)= dangerLoc{k};
					      probd(1)=uncertainty; 
					   
					      nxtNx(2)= nodesX{network(x,a1)};
					      probx(2)= (1-uncertainty)/(options_1x3(x)-1);
					      if (k==1)
						 nxtD(2)=dangerLoc{2};
					      else 
						 nxtD(2)=dangerLoc{1};
					      end 
					      probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger 
					elseif(a1<3)%HendComment: the four directions 
						if (network(x,a1)~=0)%HendComment: i cannot check if there is danger or not in this case becasue i dont care about the obvservation, we put probability for actions given T(s,a,s') 
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1)= uncertainty;
						    nxtD(1)= dangerLoc{k};
						    probd(1)=uncertainty;
						  
						    nxtNx(2)= nodesX{x};
						    probx(2)= (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger becaue probd is prob of danger  
						else%HendComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						    probx(2) = (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1); 
						end 
					end %HendComment: end the actions within node 3 
				%----------(2)agent x in node 6 where the victim is in--------------------------------------------------------
				%HendQuestion: does it matter if victim exists or not? this robot will locate victim? but what if he does not have the ability to recognize a victim? IN STOP action: actually not because we dont care about observation at this stage 
				%HendQuestion: do we need to put prob of victim or not? 
				elseif(x==1)
					if(a1==4) %HendComment: 6 is clear_danger 
						   nxtNx(1)= nodesX{x};
						   probx(1)=uncertainty;
						   nxtD(1)= dangerLoc{k};
						   probd(1)=uncertainty;
						   
						   nxtNx(2)= nodesX{network(x,a1)};
						   probx(2)= (1-uncertainty)/(options_1x3(x)-1);
						   if (k==1)
						    nxtD(2)=dangerLoc{2};
						   else 
						    nxtD(2)=dangerLoc{1};
						   end 
						   probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger 
					elseif(a1==3)%HendComment: action 5 is STOP 
						   nxtNx(1)= nodesX{x};
						   probx(1)= uncertainty;
						   nxtD(1)= dangerLoc{k};
						   probd(1)=uncertainty;
						   
						   nxtNx(2)= nodesX{network(x,a1)};
						   probx(2)=(1-uncertainty)/(options_1x3(x)-1);
						  if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						    nxtD(2)=dangerLoc{2};
						  else 
						    nxtD(2)=dangerLoc{1};
						  end 
						  probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger 
					elseif(a1<3)%HendComment: these are the four directions
						if(network(x,a1)~=0)
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1)= uncertainty;
						    nxtD(1)= dangerLoc{k};
						    probd(1)=uncertainty;
						  
						    nxtNx(2)= nodesX{x};
						    probx(2)= (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger becaue probd is prob of danger  
					      else%HendComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						    probx(2) = (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1);
					      end
									
					end %end if action x in node 6
				%----------(3)agent x in any other node than 3 and 6 -----------------------------------------------------------------
				else
					if(a1==4) %HendComment: 6 is clear_danger 
						nxtNx(1)= nodesX{x};
						probx(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					        
					        nxtNx(2)= nodesX{network(x,a1)};
					        probx(2) = (1-uncertainty)/(options_1x3(x)-1);%HendComment: the options_1x3(x)-1 will return the number of options_1x3 starting from this node. and the -1 is including stay in the same node 
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options_1x3(8)-1);%HendComment: the options_1x3(8) are the options_1x3 of the danger 
					elseif(a1==3)%HendComment: action 5 is STOP 
						nxtNx(1)= nodesX{x};
						probx(1) =uncertainty;
					        nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
					        probd(1)=uncertainty;%HendComment:the danger
					        
					        nxtNx(2)=  nodesX{network(x,a1)};
					        probx(2) = (1-uncertainty)/(options_1x3(x)-1);
					        if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						  nxtD(2)=dangerLoc{2};
					        else 
						  nxtD(2)=dangerLoc{1};
					        end 
					        probd(2)=(1-uncertainty)/(options_1x3(8)-1);
					elseif(a1<3)%HendComment: these are the four directions
						if(network(x,a1)~=0)
						    nxtNx(1)= nodesX{network(x,a1)};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
					        
						    nxtNx(2)=  nodesX{x};
						    probx(2) = (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1);
						else%HencComment: (network(x,a1)==0)
						    nxtNx(1)= nodesX{x};
						    probx(1) =uncertainty;
						    nxtD(1)= dangerLoc{k};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						    probd(1)=uncertainty;%HendComment:the danger
						   						    
						    nxtNx(2)=  nodesX{network(x,a1)+1};
						   
						    probx(2) = (1-uncertainty)/(options_1x3(x)-1);
						    if (k==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						      nxtD(2)=dangerLoc{2};
						    else 
						      nxtD(2)=dangerLoc{1};
						    end 
						    probd(2)=(1-uncertainty)/(options_1x3(8)-1);
						end				
					end %end if actionx for any other node (not 3 or 6)
				end %end if node x 
                           
                            %===============AGENT Z=========================================================================================================
				%----------(1)agent z in node 3 ---------------------------------------------------------------
				if(z==2)
					if(a3==4)%HendComment: the action is to extract_victim while it is in the node of danger 
					      nxtNz(1)=nodesZ{z};
					      probz(1)=uncertainty;
					      nxtV(1)= victimLoc{w};
					      probv(1)=uncertainty;
					      
					      nxtNz(2)=nodesZ{network(z,a3)};
					      probz(2)=(1-uncertainty)/(options_1x3(z)-1);
					      nxtV(2)= victimLoc{w};
					      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						   nxtV(2)=victimLoc{2};
					      else 
						   nxtV(2)=victimLoc{1};
					      end 
					      probv(2)=(1-uncertainty)/(options_1x3(z)-1);
					elseif(a3==3) %HendComment: the action is stop------ same as action exttract victim in this case 
					      nxtNz(1)=nodesZ{z};
					      probz(1)=uncertainty;
					      nxtV(1)= victimLoc{w};
					      probv(1)=uncertainty;
					      
					      nxtNz(2)=nodesZ{network(z,a3)};
					      probz(2)=(1-uncertainty)/(options_1x3(z)-1);
					      nxtV(2)= victimLoc{w};
					      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
						   nxtV(2)=victimLoc{2};
					      else 
						   nxtV(2)=victimLoc{1};
					      end 
					      probv(2)=(1-uncertainty)/(options_1x3(z)-1);
					elseif(a3<3)
						if(network(z,a3)~=0)
						      nxtNz(1)= nodesZ{network(z,a3)};
						      probz(1) =uncertainty;
						      nxtV(1)= victimLoc{w};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probv(1)=uncertainty;%HendComment:the danger
					        
						      nxtNz(2)=  nodesZ{z};
						      probz(2) = (1-uncertainty)/(options_1x3(z)-1);
						      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtV(2)=victimLoc{2};
						      else 
							nxtV(2)=victimLoc{1};
						      end 
						      probv(2)=(1-uncertainty)/(options_1x3(9)-1);
						else%HencComment: (network(z,a3)==0)
						      nxtNz(1)= nodesZ{z};
						      probz(1) =uncertainty;
						      nxtV(1)= victimLoc{w};%HendComment:will stay as it is because it is not in this node and the prob of that will be high as it does not need to be changed 
						      probv(1)=uncertainty;%HendComment:the danger
					        
						      nxtNz(2)=  nodesZ{network(z,a3)+1};
						      probz(2) = (1-uncertainty)/(options_1x3(z)-1);
						      if (w==1)%HendComment: i put this if because i am not sure in this case if danger exist or not in either cases we cant change this, we are not in the node of the danger (3)
							nxtV(2)=victimLoc{2};
						      else 
							nxtV(2)=victimLoc{1};
						      end 
						      probv(2)=(1-uncertainty)/(options_1x3(9)-1);
						end								
					end %end if action  z for node 3 
				%----------(2)agent z in node 6 where there is a victim ----------------------------------------------------------------
				elseif(z==1)
					if(a3==4)%HendComment: action is to extract_victim
						if(w==1)%HendComment: means that victim exists 
                                                  nxtNz(1)=nodesZ{z}; 
                                                  probz(1)= uncertainty;
                                                  nxtV(1)= victimLoc{2};
                                                  probv(1)=uncertainty;
                                                  
                                                  nxtNz(2)=nodesZ{network(z,a3)}; 
                                                  probz(2)= (1-uncertainty)/(options_1x3(z)-1);
                                                  nxtV(1)= victimLoc{1};
                                                  probv(2)=(1-uncertainty)/(options_1x3(9)-1);
                                    		else %HendComment: if victim does not exist
                                    		  nxtNz(1)=nodesZ{z}; 
                                    		  probz(1)= uncertainty;
                                                  nxtV(1)= victimLoc{w};
                                                  probv(1)=uncertainty;
                                    		  
                                    		  nxtNz(2)= nodesZ{network(z,a3)+1}; 
                                                  probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						  nxtV(1)= victimLoc{1};
                                                  probv(2)=(1-uncertainty)/(options_1x3(9)-1);
						end 
					elseif(a3==3)%HendComment: action is stop 
						nxtNz(1)= nodesZ{z};
						probz(1)=uncertainty;
						nxtV(1)= victimLoc{w};
						probv(1)=uncertainty; 
					   
						nxtNz(2)= nodesZ{network(z,a3)};
						probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						if (w==1)
						  nxtV(2)=victimLoc{2};
						else 
						  nxtV(2)=victimLoc{1};
						end 
						probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the danger 
					elseif(a3<3)%HendComment: action is one of the 4 directions 
						if(network(z,a3)~=0)
						    nxtNz(1)= nodesZ{network(z,a3)};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the victim 
						else %HendComment: (network(z,a3)==0))
						    nxtNz(1)= nodesZ{z};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the victim 
						end
					end %end if actionz for node 6
				%----------(3)agent z in any node ----------------------------------------------------------------------
				else%HendComment: z any node than 3 and 6
					if(a3==4)%Hendcomment: 6 is the extrac victim action 
					    nxtNz(1)=nodesZ{z};
					    probz(1)=uncertainty;
					    nxtV(1)= victimLoc{w};
					    probv(1)=uncertainty;
					
					    nxtNz(2)=nodesZ{network(z,a3)};
					    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
					    if (w==1)
						  nxtV(2)=victimLoc{2};
					    else 
						  nxtV(2)=victimLoc{1};
					    end 
					    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the victim 
					elseif(a3==3) %HendComment: 5 is the stop action
					    nxtNz(1)= nodesZ{z};
					    probz(1)=uncertainty;
					    nxtV(1)= victimLoc{w};
					    probv(1)=uncertainty; 
					   
					    nxtNz(2)= nodesZ{network(z,a3)};
					    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
					    if (w==1)
					      nxtV(2)=victimLoc{2};
					    else 
					      nxtV(2)=victimLoc{1};
					    end 
					    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the danger 
					elseif(a3<3)
						if(network(z,a3)~=0)
						    nxtNz(1)= nodesZ{network(z,a3)};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the victim 
						else %HendComment: (network(z,a3)==0))
						    nxtNz(1)= nodesZ{z};
						    probz(1)=uncertainty;
						    nxtV(1)= victimLoc{w};
						    probv(1)=uncertainty; 
						
						    nxtNz(2)= nodesZ{z};
						    probz(2)= (1-uncertainty)/(options_1x3(z)-1);
						    if (w==1)
						      nxtV(2)=victimLoc{2};
						    else 
						      nxtV(2)=victimLoc{1};
						    end 
						    probv(2)=(1-uncertainty)/(options_1x3(9)-1);%HendComment: the options_1x3(9) are the options_1x3 of the victim 
						end
					end %end if action z for any other node (not 3 or 6)
				end %end if node z                   
				%==========================================Print the probability=====================================
				%HendComment: I am not sure if this is the correct way for the probability if all was correct then the joint was correct? this is how i did it 
%                  if((probx(1)==uncertainty)&& (probz(1)==uncertainty)&&(probd(1)==uncertainty)&&(probv(1)==uncertainty))
%                      uniProb1=uncertainty; 
%                  else 
%                      uniProb1=1-uncertainty; 
%                  end 
%                  
%                  if((probx(2)==uncertainty)&& (probz(2)==uncertainty)&&(probd(2)==uncertainty)&&(probv(2)==uncertainty))
%                      uniProb2=uncertainty; 
%                  else 
%                      uniProb2=1-uncertainty; 
%                  end 
				uniProb1= probx(1)*probz(1)*probd(1)*probv(1);
				uniProb2= 1-uniProb1;
				%uniProb2= probx(2)*probz(2)*probd(2)*probv(2);

                                fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k},nxtNx(1),nxtNz(1),nxtV(1),nxtD(1),uniProb1);                                               
                                fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k},nxtNx(2),nxtNz(2),nxtV(2),nxtD(2),uniProb2);                                               
   
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
%   fprintf(fid,'\nO: * :\nuniform');
o_uncertainty =0.9;

for a1=1:length(agent1Actions)
  for a3=1:length(agent3Actions)
    for x=1:length(nodesX)
      for z=1:length(nodesZ)
        for k=1:length(dangerLoc)
          for w=1:length(victimLoc)
            for o1=1:length(agent1Observation)
              for o3=1:length(agent3Observation)
                  endStateX=zeros;
                  endStateZ=zeros;
                  obsX=0;
                  obsZ=0;
                  probO1=0;
                  probO3=0;
                  uniprob1=0;
                  uniprob2=0;


                    if(network(x,a1)~=0)
                        endStateX(1)= nodesX{network(x,a1)};
                        endStateX(2)= nodesX{x};
                        if(x==2 && k==1)
                          obsX=2;
                        elseif (x==1 && w==1)
                          obsX=1;
                        else
                          obsX=3;
                        end
                    else
                        endStateX(1)= nodesX{x};
                        endStateX(2)=  nodesX{x};
                        if(x==2 && k==1)
			  obsX=2;
                        elseif (x==1 && w==1)
                          obsX=1;
                        else
                          obsX=3;
                        end
                    end



                     if(network(z,a3)~=0)
                        endStateZ(1)= nodesZ{network(z,a3)};
                        endStateZ(2)= nodesZ{z};
                        if(z==2 && k==1)
                          obsZ=2;
                        elseif (z==1 && w==1)
                          obsZ=1;
                        else
                          obsZ=3;
                        end
                     else
                        endStateZ(1)= nodesZ{z};
                        endStateZ(2)= nodesZ{z};
                        if(z==2 && k==1)
                          obsZ=2;
                        elseif (z==1 && w==1)
                          obsZ=1;
                        else
                          obsZ=3;
                        end
                     end


                  if(o1==obsX)
                      prob01=o_uncertainty;
                  else
                      prob01=(1-o_uncertainty)/2;
                  end

                  if(o3==obsZ)
			probO3=o_uncertainty;
                  else
                      probO3=(1-o_uncertainty)/2;
                  end

                  uniprob1=prob01*probO3;
                  uniprob2=1/10;
                  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},endStateX(1),endStateZ(1),victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniprob1);
                  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},endStateX(2),endStateZ(2),victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniprob1);

              end
            end
          end
        end
      end
    end
  end
end


%  for x=1:length(nodesX)
%    for z=1:length(nodesZ)
%      for w=1:length(victimLoc)
%        for k=1:length(dangerLoc)
%  	for a1=1:length(agent1Actions)
%  	  for a3=1:length(agent3Actions)
%  %  	    obs1String = '';
%  %  	    obs3String = '';
%  
%  	    uniprob1=0;
%  	    uniprob2=0;
%  	   
%  	    endStateX=zeros; 
%  	    endStateZ=zeros; 
%  	    endStateV=zeros;
%  	    endStateD=zeros; 
%  	    probX=0;
%  	    probZ=0; 
%  %  	    probV=0;
%  %  	    probD=0; 
%  	    
%  	    obsX=zeros; 
%  	    obsZ=zeros;
%  
%  	   %============Robot Agent X======================
%  	   if (x=1)%where the victim is
%  	      if (a1=4)%clear_danger
%  	      
%  	      elseif(a1=3)%stop
%  	      
%  	      else%direction  
%  	      
%  	      end
%  	   elseif (x=2)%where the danger is 
%  	      if (a1=4)%clear_danger
%  	      elseif(a1=3)%stop
%  	      else%direction  
%  	      end
%  	   else%where there is no danger nor victim (in this case x=3)
%  	      if (a1=4)%clear_danger
%  	      elseif(a1=3)%stop
%  	      else%direction (in this case we have two directions right and left)  
%  			if(network(x,a1)~=0)
%  			  endStateX(1)= nodesX{network(x,a1)};
%  			else
%  			  endStateX(2)= nodesX{x};
%  			end
%  			if(x=2 && k=1)
%  			  obsX(1)= 2; % 2 is agent1Observation{2} but because it is an array i can't put string of the observation it has to be one digit or character 
%  			else
%  			  obsX(1)= 3;%novic_nodan
%  			end 
%  			  probX=o_uncertainty;
%  	      end
%  	   end 
%  	   %=============Human Agent Z===========================
%  	   if(z=1)
%  	    if (a3=4)%Extract_victim
%  	    elseif(a3=3)%stop
%  	    else%direction  
%  	    end
%  	   elseif(z=2)
%  	    if (a3=4)%Extract_victim
%  	    elseif(a3=3)%stop
%  	    else%direction  
%  	    end
%  	   else
%  	    if (a3=4)%Extract_victim
%  	    elseif(a3=3)%stop
%  	    else%direction  
%  	    end
%  	   end 
%  	   
%  	   for o1=1:length(agent1Observation)
%  	      for o2=1:length(agent3Observation)
%  		    fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{xxx},victimLoc{w},dangerLoc{k},obs1String,obs3String,uniprob1);
%  	      end
%  	  end

%  	    %==========================Observation agent1 ==============================
%  	    if(strcmp( nodesX{x}, 'a')   && strcmp(victimLoc{w},'a'))
%  	      obs1String = 'vic';
%  	    else
%  	      obs1String = 'noVic';
%  	    end
%  	    
%  	    if(strcmp( nodesX{x}, 'b')   && strcmp(dangerLoc{k},'b'))
%  	      obs1String = strcat(obs1String,'_dan');
%  	    else 
%  	      obs1String = strcat(obs1String,'_noDan');
%  	    end
%  	    %=======================Observation agent3 ===================================
%  	    if(strcmp( nodesZ{xxx}, 'a')   && strcmp(victimLoc{w},'a'))
%  	      obs3String = 'vic';
%  	    else
%  	      obs3String = 'noVic';
%  	    end
%  	    
%  	    if(strcmp( nodesZ{xxx}, 'b')  && strcmp(dangerLoc{k},'b'))
%  	      obs3String = strcat(obs3String,'_dan');
%  	    else 
%  	      obs3String = strcat(obs3String,'_noDan');
%  	    end
%          
%  	    %check if victim is there (state) and action is extract-- check if danger is there (state) and action is clear danger if not (1-uncertainty) 
%  	    
%  	    if((x==2) && (k==1)&&(a1==4) && ((strcmp(obs1String,'vic_dan'))||(strcmp(obs1String,'noVic_dan')))) 
%  		if((xxx==1) &&(w==1)&& (a3==4) && ((strcmp(obs3String,'vic_dan'))||(strcmp(obs3String,'vic_noDan'))))
%  		  prob1=o_uncertainty;
%  		else
%  		  prob2=1-o_uncertainty;
%  		end 
%  	    else 
%  		if((xxx==1) &&(w==1)&& (a3==4) && ((strcmp(obs3String,'vic_dan'))||(strcmp(obs3String,'vic_noDan'))))
%  		  prob1=o_uncertainty;
%  		else
%  		  prob2=1-o_uncertainty;
%  		end 
%  	    end 
%  
%  	    uniprob1=prob1+prob2+prob3+prob4;
%  	    
%  	    fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{xxx},victimLoc{w},dangerLoc{k},obs1String,obs3String,uniprob1);
%  	    
%  	    %-----------if in node where danger (node b) 
%  	    % agent1Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};
%  
%  	    fprintf(fid,'\nO: %s %s : b_b_%s_b :  noVic_dan noVic_dan :%f',agent1Actions{a1},agent3Actions{a3},victimLoc{2},dangerLoc{1},0.9);
%  	    
%  
%  
%  	  end
%  	end
%        end
%      end
%    end 
%  end
 
% Build Reward Function
% Typical problems only use R(s,ja) which is specified by:
%   R: <a1 a2...an> : <start-state> : * : * : %f
%   or
%   R: <a1 a2...an> : <start-state> : <end-state> : <observation> %f

%---------------- Useless motions are penalised----------------------------
%fprintf(fid,'\nR: * : * : * : * : -1.0');
fprintf(fid,'\nR: * : * : * : * : -10.00');

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

 for a1=1:length(agent1Actions)
      for x=1:length(nodesX)
          for xxx=1:length(victimLoc)
                fprintf(fid,'\nR: %s stop : %s_b_%s_b : * :  * : -95', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});
                fprintf(fid,'\nR: %s extract_victim : %s_b_%s_b : * :  * : -95', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});

          end 
      end 
  end 

%----------------- penality for when robot clears danger and there is no danger------------------------- 

 for a3=1:length(agent3Actions)
      for x=1:length(nodesX)
	 for z=1:length(nodesZ)
            for v=1:length(victimLoc)
                fprintf(fid,'\nR: clear_danger %s : %s_%s_%s_n : * :  * : -50', agent3Actions{a3}, nodesX{x}, nodesZ{z}, victimLoc{v});
	    end
          end 
      end 
  end 
  
%----------------- penality for extract victim and there is no victim------------------------- 

 for a1=1:length(agent1Actions)
      for x=1:length(nodesX)
	 for z=1:length(nodesZ)
            for d=1:length(dangerLoc)
                fprintf(fid,'\nR: %s extract_victim : %s_%s_n_%s : * :  * : -50', agent1Actions{a1}, nodesX{x}, nodesZ{z}, dangerLoc{d});
	    end
          end 
      end 
  end 
 
%  %----------------- penality for extract victim and clear danger where there is no danger and no victim------------------------- 
%        for x=1:length(nodesX)
%  	 for z=1:length(nodesZ)
%                  fprintf(fid,'\nR: clear_danger extract_victim : %s_%s_n_n : * :  * : -50', nodesX{x}, nodesZ{z});
%            end 
%        end 
%--------------- HUman stop when node 3 has danger --------------------

%  for a1=1:length(agent1Actions)
%      for a3=1:length(agent3Actions)
%  	for x=1:length(nodesX)
%  		for xxx=1:length(nodesZ)
%  		     if (strcmp(nodesX{x},'b'))
%  			if ( strcmp(nodesZ{xxx},'a') ||  strcmp(nodesZ{xxx},'c'))
%  			      if( strcmp(agent1Actions{a1},'clear_danger'))
%  				  fprintf(fid,'\nR: %s stop : %s_%s_a_b : * : * : 30', agent1Actions{a1},nodesX{x}, nodesZ{xxx});
%  				  fprintf(fid,'\nR: %s stop : %s_%s_n_b : * : * : 30', agent1Actions{a1},nodesX{x}, nodesZ{xxx});
%  			      end
%  			end
%  		     end
%  		end 
%  	    
%  	end 
%      end
%  end 
%--------------- HUman stop when node b has danger --------------------

%	for x=1:length(nodesX)
%		for z=1:length(nodesZ)
%		     if (x==2)
%			if (z~=2)
%			  fprintf(fid,'\nR: clear_danger stop : %s_%s_a_b : * : * : 20', nodesX{x}, nodesZ{z});
%			  fprintf(fid,'\nR: clear_danger stop : %s_%s_n_b : * : * : 20', nodesX{x}, nodesZ{z});
%			end
%		     end
%		end 
%	end 
% -----------------Reward for clearing danger----------------------------------
for a3=1:length(agent3Actions)
  for z=1:length(nodesZ)
    for v=1:length(victimLoc)                
      fprintf(fid,'\nR:  clear_danger %s : b_%s_%s_b :  * : * : 100',agent3Actions{a3}, nodesZ{z}, victimLoc{v});
    end
  end 
end

 
%--------------- Extracting a victim is highly rewarded--------------------
for x=1:length(nodesX)
for a1=1:length(agent1Actions)
	for k=1:length(dangerLoc)
	  fprintf(fid,'\nR:  %s extract_victim : %s_a_a_%s : * : * : 100', agent1Actions{a1},nodesX{x},dangerLoc{k});
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
