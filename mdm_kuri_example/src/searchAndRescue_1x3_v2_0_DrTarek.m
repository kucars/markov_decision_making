%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X,  agent 2 is Z
agent1Loc         = {'a','b','c'};
agent2Loc         = {'a','b','c'};
dangerLoc         = {'b','n'};%n means no danger
victimLoc         = {'a','n'};%n means no victim 

dangerLocState = 2;
victimLocState = 1;

agent1Actions     = {'right','left','stop','clear_danger'};
agent2Actions     = {'right','left','stop','extract_victim'};

%  agent1Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};
%  agent3Observation = {'vic_dan','vic_noDan','noVic_dan','noVic_noDan'};

agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
agent3Observation = {'vic_noDan','noVic_dan','noVic_noDan'};


%right,left,stop,clear/extract
%-------------------------------
%  a(v)   |     b(d)   |    c   |
%-------------------------------
% a,b,c {right, left, stop, clear/extract}
network =[[2,1,1,1];[3,1,2,2];[3,2,3,3]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_1x3_v2_0.dpomdp';  
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

for x=1:length(agent1Loc)
        for z=1:length(agent2Loc)
            for w=1:length(victimLoc)
                for k=1:length(dangerLoc)
                    fprintf(fid,'%s_%s_%s_%s ',agent1Loc{x},agent2Loc{z},dangerLoc{k},victimLoc{w});
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
for a2=1:length(agent2Actions)
  fprintf(fid,'%s ',agent2Actions{a2});
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
%****************
%****************
%i have put the options_1x3 function to count the number of options_1x3 for each node where the next node should be. but there is an extra issue 
% which is the danger and victim.. shouldn't those nodes with these targets should be added as options_1x3 too next state could be them too! 
% wouldnt be like the  next node (as a state) associated with the next danger or victim states?!?!?
%****************
%****************

% How many actions per state:
a1StateSpace = size(agent1Loc)(2);
a2StateSpace = size(agent2Loc)(2);
dStateSpace  = size(dangerLoc)(2);
vStateSpace  = size(victimLoc)(2);

certainty = 0.9; 
for a1=1:length(agent1Actions)
  for a2=1:length(agent2Actions)
  
    for s1=1:length(agent1Loc)
      for s2=1:length(agent2Loc)
        for sd=1:length(dangerLoc) 
	  for sv=1:length(victimLoc)
                sum = 0;
		  for s1p=1:length(agent1Loc)
		    for s2p=1:length(agent2Loc)
                      for sdp=1:length(dangerLoc) 
		        for svp=1:length(victimLoc)

			  if(s1p==network(s1,a1))
			    probx=certainty;
			  else 
			    probx=(1-certainty)/(a1StateSpace-1);
			  end 
              
			  if (s2p==network(s2,a2))
			    probz=certainty;
			  else 
			    probz=(1-certainty)/(a2StateSpace-1);
			  end
	     
                          % This what should happen here:
                          % If we are in a danger state and we took an action clear danger, then we should transition to a no danger state
                          % with very high probability
                          % Any other action will not change the danger state (high prob)
                          % The rest is noise

                          if(strcmp(agent1Actions{a1},'clear_danger') && strcmp(dangerLoc{sdp},'n'))
                            probd=certainty;
                          elseif (!strcmp(agent1Actions{a1},'clear_danger') && sd == sdp) 
                            probd=certainty;
                          else 
                            probd=(1-certainty)/(dStateSpace-1);
                          end

                          % This what should happen here:
                          % If we are in a victim state and we took an action extract victim, then we should transition to a no victim state
                          % with very high probability
                          % Any other action will not change the danger state (high prob)
                          % The rest is noise

                          if(strcmp(agent2Actions{a2},'extract_victim') && strcmp(victimLoc{svp},'n'))
                            probv=certainty;
                          elseif (!strcmp(agent2Actions{a2},'extract_victim') && sv == svp) 
                            probv=certainty;
                          else 
                            probv=(1-certainty)/(dStateSpace-1);
                          end
              
  
                          uniProb1= probx*probz*probd*probv;
                          sum = sum + uniProb1;
                          fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent2Actions{a2},agent1Loc{s1},agent2Loc{s2},dangerLoc{sd},victimLoc{sv},agent1Loc{s1p},agent2Loc{s2p},dangerLoc{sdp},victimLoc{svp},uniProb1);
			    
			end 
		      end 
		     end
		   end 
               % Sanity Check: floating point comparison hack
               if (abs(sum-1.0)>0.00001)
                printf('\n Sum for T: %s %s : %s_%s_%s_%s is:%f',agent1Actions{a1},agent2Actions{a2},agent1Loc{s1},agent2Loc{s2},dangerLoc{sd},victimLoc{sv},sum);
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

% In state a, I observe victim with high probability
% In state b, I observe danger with high probability


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



                     if(network(z,a2)~=0)
                        endStateZ(1)= nodesZ{network(z,a2)};
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
                  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a2},endStateX(1),endStateZ(1),victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniprob1);
                  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a2},endStateX(2),endStateZ(2),victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniprob1);

              end
            end
          end
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
                fprintf(fid,'\nR: %s stop : %s_b_%s_b : * :  * : -150', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});
                fprintf(fid,'\nR: %s extract_victim : %s_b_%s_b : * :  * : -150', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});

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
