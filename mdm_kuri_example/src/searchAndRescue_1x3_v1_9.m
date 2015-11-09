%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X,  agent 2 is Z
nodesX            = {'a','b', 'c'};
nodesZ            = {'a','b', 'c'};
victimLoc         = {'a','n'};%n means no victim 
dangerLoc         = {'b','n'};%n means no danger

victimLocState = 1;
dangerLocState = 2;

agent1Actions     = {'right','left','stop','clear_danger'};
agent3Actions     = {'right','left','stop','extract_victim'};

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
outputFile = 'MAHRC_1x3_v1_9.dpomdp';  
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


%HencComment: remember array start the index from 1 not zero 
%  
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

		  for x1=1:length(nodesX)
		    for z1=1:length(nodesZ)
		      for w1=1:length(victimLoc)
			for k1=1:length(dangerLoc) 

			    probx= 0.0;
			    probz= 0.0;
			    probd= 0.0;
			    probv= 0.0; 
			    uniProb1=0.0;  

			  if(x1 == network(x,a1))
			    probx=uncertainty;
			  else
			    probx=(1-uncertainty)/2;
			  end 
              
			  if (z1 == network(z,a3))
			    probz=uncertainty;
			  else
			    probz=(1-uncertainty)/2;
			  end
	     
	     
	     
			  if (x== dangerLocState && k==1 && a1==4 && k1==2)
			    probd=uncertainty;
			  elseif (x== dangerLocState && k==1 && a1<4 && k1==k)
			    probd=uncertainty;
			  elseif (x== dangerLocState && k==2 && k1==k)
			    probd=uncertainty;
			  elseif (x~= dangerLocState && k==2 &&  a1<4 && k1==k)
			    probd=uncertainty;
			  elseif (x~= dangerLocState && k1==k)
			    probd=uncertainty;
			  else
			    probd=1-uncertainty;
			  end 
                            
                            
			  if (z== victimLocState && w==1 && a3==4 && w1==2 )
			    probv=uncertainty;
			  elseif (z== victimLocState && w==1 && a3<4 && w1==w )
			    probv=uncertainty;
			  elseif (z== victimLocState && w==2 && w1==w )
			    probv=uncertainty;
			  elseif (z~= victimLocState && a3<4 && w1==w && w==2)
			    probv=uncertainty;
			  elseif (z~= victimLocState && w1==w )
			    probv=uncertainty;
			  else 
			    probv=1-uncertainty;
			  end                
			   
			   
			    uniProb1= probx*probz*probd*probv;

			    fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k},nodesX{x1},nodesZ{z1},victimLoc{w1},dangerLoc{k1},uniProb1);
			    
			end 
		      end 
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

% In state a, I observe victim with high probability
% In state b, I observe danger with high probability


% Add uniformity just in case we missed something
%   fprintf(fid,'\nO: * :\nuniform');
obsUncertainty =0.9;

for a1=1:length(agent1Actions)
  for a3=1:length(agent3Actions)
    for x=1:length(nodesX)
      for z=1:length(nodesZ)
	for w=1:length(victimLoc)
	  for k=1:length(dangerLoc)
	  sum=0.0;
	    for o1=1:length(agent1Observation)
              for o3=1:length(agent3Observation)
              
		  probO1=0.0;
                  probO3=0.0;
		  uniProb1=0.0;  
		  
		  if(x==1 && w==1 && o1 ==1)
		    probO1= obsUncertainty;
		  elseif(x==1 && w==2 && o1 ==3)
		     probO1= obsUncertainty;
		  elseif ( x==2 && k==1 && o1==2)
		     probO1= obsUncertainty;
		  elseif ( x==2 && k==2 && o1==3)
		     probO1= obsUncertainty;
		  elseif (x==3 && o1==3)
		      probO1= obsUncertainty;
		  else 
		     probO1= (1-obsUncertainty)/2;
		  end 

		  if(z==1 && w==1 && o3 ==1)
		    probO3= obsUncertainty;
		  elseif(z==1 && w==2 && o3 ==3)
		     probO3= obsUncertainty;
		  elseif ( z==2 && k==1 && o3==2)
		     probO3= obsUncertainty;
		  elseif ( z==2 && k==2 && o3==3)
		     probO3= obsUncertainty;
		  elseif (z==3 && o3==3)
		      probO3= obsUncertainty;
		  else 
		     probO3= (1-obsUncertainty)/2;
		  end 
		  
		  
		  uniProb1=probO1*probO3;
		  sum = sum + uniProb1;
		  
		  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniProb1);
              
              
              
              end 
            end
            
             % Sanity Check: floating point comparison hack
               if (abs(sum-1.0)>0.00001)
                printf('\n Sum for O: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},nodesX{x},nodesZ{z},victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},sum);
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

%----------------- penality for human go to danger------------------------- 

 for a1=1:length(agent1Actions)
      for x=1:length(nodesX)
          for xxx=1:length(victimLoc)
                fprintf(fid,'\nR: %s stop : %s_b_%s_b : * :  * : -100', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});
                fprintf(fid,'\nR: %s extract_victim : %s_b_%s_b : * :  * : -100', agent1Actions{a1}, nodesX{x}, victimLoc{xxx});

          end 
      end 
  end 

%----------------- penality for  robot clears danger and there is no danger------------------------- 

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
 

 
% -----------------Reward for clearing danger----------------------------------
for a3=1:length(agent3Actions)
  for z=1:length(nodesZ)
    for v=1:length(victimLoc)                
      fprintf(fid,'\nR:  clear_danger %s : b_%s_%s_b :  * : * : 130',agent3Actions{a3}, nodesZ{z}, victimLoc{v});
    end
  end 
end

 
%--------------- Extracting a victim is highly rewarded--------------------
for x=1:length(nodesX)
for a1=1:length(agent1Actions)
	for k=1:length(dangerLoc)
	  fprintf(fid,'\nR:  %s extract_victim : %s_a_a_%s : * : * : 130', agent1Actions{a1},nodesX{x},dangerLoc{k});
	end
    end
end 




fprintf(fid,'\n');

fclose(fid);
