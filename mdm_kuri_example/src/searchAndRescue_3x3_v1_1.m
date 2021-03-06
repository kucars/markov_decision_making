%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X,  agent 2 is Z
agent1Loc = {'a','b', 'c','d','e','f'};
agent2Loc = {'a','b', 'c','d','e','f'};
dangerLoc = {'d','n'};%n means no danger
victimLoc = {'f','n'};%n means no victim 

victimLocState = 6;%the node 
dangerLocState = 4;

agent1Actions     = {'right','left','up','down','stop','clear_danger'};
agent3Actions     = {'right','left','up','down','stop','extract_victim'};

agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
agent3Observation = {'vic_noDan','noVic_dan','noVic_noDan'};


%right,left,stop,clear/extract
%--------------------------------
%  f(V)   |            |    e   |
%--------------------------------
%xxxxxxxxx|xxxxxxxxxxxx|    d(D)|
%--------------------------------
%  a(R)   |     b(H)   |    c   |
%--------------------------------
% a,b,c,d,e,f {right, left, up, down, stop, clear/extract}
%a=1,b=2,c=3,d=4,e=5,f=6
network =[[2,1,1,1,1,1];[3,1,2,2,2,2];[3,2,4,3,3,3];[4,4,5,3,4,4];[5,6,5,4,5,5];[5,6,6,6,6,6]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_3x3_v1_1.dpomdp';  
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
                    fprintf(fid,'%s_%s_%s_%s ',agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k});
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


uncertainty = 0.9; 
for a1=1:length(agent1Actions)
  for a3=1:length(agent3Actions)
    for x=1:length(agent1Loc)
      for z=1:length(agent2Loc)
	for w=1:length(victimLoc)
	  for k=1:length(dangerLoc) 
	    sum = 0;
		  for x1=1:length(agent1Loc)
		    for z1=1:length(agent2Loc)
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
			    probx=(1-uncertainty)/5;%5 is the other nodes that it will be written except itself 
			  end 
              
			  if (z1 == network(z,a3))
			    probz=uncertainty;
			  else
			    probz=(1-uncertainty)/5;
			  end
	     
	     
	     
			  if (x== dangerLocState && k==1 && a1==6 && k1==2)
			    probd=uncertainty;
			  elseif (x== dangerLocState && k==1 && a1<6 && k1==k)
			    probd=uncertainty;
			  elseif (x== dangerLocState && k==2 && k1==k)
			    probd=uncertainty;
			  elseif (x~= dangerLocState && k==2 &&  a1<6 && k1==k)
			    probd=uncertainty;
			  elseif (x~= dangerLocState && k1==k)
			    probd=uncertainty;
			  else
			    probd=1-uncertainty;
			  end 
                            
                            
			  if (z== victimLocState && w==1 && a3==6 && w1==2 )
			    probv=uncertainty;
			  elseif (z== victimLocState && w==1 && a3<6 && w1==w )
			    probv=uncertainty;
			  elseif (z== victimLocState && w==2 && w1==w )
			    probv=uncertainty;
			  elseif (z~= victimLocState && a3<6 && w1==w && w==2)
			    probv=uncertainty;
			  elseif (z~= victimLocState && w1==w )
			    probv=uncertainty;
			  else 
			    probv=1-uncertainty;
			  end                
			   
			   
			    uniProb1= probx*probz*probd*probv;
			    sum = sum + uniProb1;

			    fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent3Actions{a3},agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k},agent1Loc{x1},agent2Loc{z1},victimLoc{w1},dangerLoc{k1},uniProb1);
			    
			end 
		      end 
		     end
		   end 
		   % Sanity Check: floating point comparison hack
		    if (abs(sum-1.0)>0.00001)
		    printf('\n Sum for T: %s %s : %s_%s_%s_%s is:%f',agent1Actions{a1},agent3Actions{a3},agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k},sum);
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
    for x=1:length(agent1Loc)
      for z=1:length(agent2Loc)
	for w=1:length(victimLoc)
	  for k=1:length(dangerLoc)
	  sum=0.0;
	    for o1=1:length(agent1Observation)
              for o3=1:length(agent3Observation)
              
		  probO1=0.0;
                  probO3=0.0;
		  uniProb1=0.0;  
		  
		  if(x==6 && w==1 && o1 ==1)
		    probO1= obsUncertainty;
		  elseif(x==6 && w==2 && o1 ==3)
		     probO1= obsUncertainty;
		  elseif ( x==4 && k==1 && o1==2)
		     probO1= obsUncertainty;
		  elseif ( x==4 && k==2 && o1==3)
		     probO1= obsUncertainty;
		  elseif (x~=4 && x~=6 && o1==3)
		      probO1= obsUncertainty;
		  else 
		     probO1= (1-obsUncertainty)/2;%2 is the other options of the observations 
		  end 

		  if(z==6 && w==1 && o3 ==1)
		    probO3= obsUncertainty;
		  elseif(z==6 && w==2 && o3 ==3)
		     probO3= obsUncertainty;
		  elseif ( z==4 && k==1 && o3==2)
		     probO3= obsUncertainty;
		  elseif ( z==4 && k==2 && o3==3)
		     probO3= obsUncertainty;
		  elseif (z~=4 && z~=6 && o3==3)
		      probO3= obsUncertainty;
		  else 
		     probO3= (1-obsUncertainty)/2;
		  end 
		  
		  
		  uniProb1=probO1*probO3;
		  sum = sum + uniProb1;
		  
		  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},uniProb1);

              end 
            end
            
             % Sanity Check: floating point comparison hack
               if (abs(sum-1.0)>0.00001)
                printf('\n Sum for O: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent3Actions{a3},agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k},agent1Observation{o1},agent3Observation{o3},sum);
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
	  for x=1:length(agent1Loc)
	    for v=1:length(victimLoc)
                fprintf(fid,'\nR: %s up : %s_c_%s_d : * :  * : -50', agent1Actions{a1}, agent1Loc{x},victimLoc{v});
                fprintf(fid,'\nR: %s down : %s_e_%s_d : * :  * : -50', agent1Actions{a1}, agent1Loc{x},victimLoc{v});
                 
              end
	  end 
      end 

%  %  %----------------- penality for  robot clears danger and there is no danger------------------------- 
%  
%   for a3=1:length(agent3Actions)
%        for x=1:length(agent1Loc)
%  	 for z=1:length(agent2Loc)
%              for v=1:length(victimLoc)
%                  fprintf(fid,'\nR: clear_danger %s : %s_%s_%s_n : * :  * : -50', agent3Actions{a3}, agent1Loc{x}, agent2Loc{z}, victimLoc{v});
%  	    end
%            end 
%        end 
%    end 
%    
%  %----------------- penality for  robot clears danger and robot is not in danger node------------------------- 
%  for a3=1:length(agent3Actions)
%        for x=1:length(agent1Loc)
%  	 for z=1:length(agent2Loc)
%              for v=1:length(victimLoc)
%                if(x~=4)
%                  fprintf(fid,'\nR: clear_danger %s : %s_%s_%s_d : * :  * : -50', agent3Actions{a3}, agent1Loc{x}, agent2Loc{z}, victimLoc{v});
%  	      end
%  	    end
%            end 
%        end 
%    end 
%  %----------------- penality for  robot in danger but dont clear danger------------------------- 
%  for a1=1:length(agent1Actions)
%     for a3=1:length(agent3Actions)
%  	 for z=1:length(agent2Loc)
%              for v=1:length(victimLoc)
%  	      if(a1~=6)
%                  fprintf(fid,'\nR: %s %s : d_%s_%s_d : * :  * : -50', agent1Actions{a1},agent3Actions{a3}, agent2Loc{z}, victimLoc{v});
%                 end
%  	    end
%            end 
%    end 
%  end
%  %----------------- penality for  human in victim node but dont extract him------------------------- 
%  for a1=1:length(agent1Actions)
%     for a3=1:length(agent3Actions)
%        for x=1:length(agent1Loc)
%              for d=1:length(dangerLoc)
%  	      if(a3~=6)
%                  fprintf(fid,'\nR: %s %s : %s_f_f_%s : * :  * : -50', agent1Actions{a1},agent3Actions{a3}, agent1Loc{x}, dangerLoc{d});
%                 end
%  	    end
%             
%        end 
%    end 
%  end
%  %----------------- penality for extract victim and human is not in node of victim------------------------- 
for a1=1:length(agent1Actions)
      for x=1:length(agent1Loc)
	 for z=1:length(agent2Loc)
            for d=1:length(dangerLoc)
	      if(z~=6)
                fprintf(fid,'\nR: %s extract_victim : %s_%s_f_%s : * :  * : -50', agent1Actions{a1}, agent1Loc{x}, agent2Loc{z}, dangerLoc{d});
               end
	    end
          end 
      end 
  end 

%  %----------------- penality for extract victim and there is no victim------------------------- 
%  
%   for a1=1:length(agent1Actions)
%        for x=1:length(agent1Loc)
%  	 for z=1:length(agent2Loc)
%              for d=1:length(dangerLoc)
%                  fprintf(fid,'\nR: %s extract_victim : %s_%s_n_%s : * :  * : -50', agent1Actions{a1}, agent1Loc{x}, agent2Loc{z}, dangerLoc{d});
%  	    end
%            end 
%        end 
%    end 
%   

 
% -----------------Reward for clearing danger----------------------------------
for a3=1:length(agent3Actions)
  for z=1:length(agent2Loc)
    for v=1:length(victimLoc)                
      fprintf(fid,'\nR:  clear_danger %s : d_%s_%s_d :  * : * : 100',agent3Actions{a3}, agent2Loc{z}, victimLoc{v});
    end
  end 
end

 
%--------------- Extracting a victim is highly rewarded--------------------
for x=1:length(agent1Loc)
   for a1=1:length(agent1Actions)
	for k=1:length(dangerLoc)
	  fprintf(fid,'\nR:  %s extract_victim : %s_f_f_%s : * : * : 100', agent1Actions{a1},agent1Loc{x},dangerLoc{k});
	end
    end
end 




fprintf(fid,'\n');

fclose(fid);
