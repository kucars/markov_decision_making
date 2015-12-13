%4x4 map, fixed victim and danger location
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is X,  agent 2 is Z
agent1Loc = {'a','b', 'c','d','e','f','g','h','i','j','k','l'};
agent2Loc = {'a','b', 'c','d','e','f','g','h','i','j','k','l'};
dangerLoc = {'c','n'};%n means no danger
victimLoc = {'g','n'};%n means no victim 

victimLocState = 7;%the node 
dangerLocState = 3;

agent1Actions     = {'right','left','up','down','stop','clear_danger'};
agent3Actions     = {'right','left','up','down','stop','extract_victim'};

agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
agent3Observation = {'vic_noDan','noVic_dan','noVic_noDan'};


%right,left,up, down,stop,clear/extract
%-----------------------------------------
%  g(V)	|	|	|	|   f	|
%-----------------------------------------
% 	| xxxxxx|xxxxxx	|xxxxxx	|	|
%-----------------------------------------
%  h	|   i	|xxxxxxx|   d	|   e	|
%-----------------------------------------
%xxxxxxx|  j	|	|  c(D)	|xxxxxxx|
%-----------------------------------------
%  k	|xxxxxxx|xxxxxxx|	|xxxxxxx|
%-----------------------------------------
%  l	|	|	|   b	| a(R,H)|
%-----------------------------------------


%{right, left, up, down, stop, clear/extract}
%a=1,b=2,c=3,d=4,e=5,f=6. g=7 h=8, i=9, j=10, k=11, l=12
network =[[1,2,1,1,1,1];[1,12,3,2,2,2];[3,10,4,2,3,3];[5,4,4,3,4,4];[5,4,6,5,5,5];[6,7,6,5,6,6];[6,7,7,8,7,7];[9,8,7,8,8,8];[9,8,9,10,9,9];[3,10,9,10,10,10];[11,11,11,12,11,11];[2,12,11,12,12,12]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_6x5_2ag_v2_1.dpomdp';  
fid = fopen(outputFile, 'wb');

% Write to File the top comments and warnings
fprintf(fid,'# This MPOMDP Model was generated MATLAB Script');
fprintf(fid,'\n# This script is still experimental and bugs might appear');
fprintf(fid,'\n# Tarek Taha & Hend Al Tair - KUSTAR\n');

fprintf(fid,'#The agents.');
fprintf(fid,'\nagents: 2');
fprintf(fid,'\ndiscount: 1.0');
fprintf(fid,'\nvalues: reward');
fprintf(fid,'\nstates:');

for x=1:length(agent1Loc)
        for z=1:length(agent2Loc)
            for v=1:length(victimLoc)
                for d=1:length(dangerLoc)
                    fprintf(fid,'%s_%s_%s_%s ',agent1Loc{x},agent2Loc{z},victimLoc{v},dangerLoc{d});
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

% How many actions per state:
a1StateSpace = size(agent1Loc)(2);%2 is to tell we need number of coloums not row (row, columns) 
a2StateSpace = size(agent2Loc)(2);
dStateSpace  = size(dangerLoc)(2);
vStateSpace  = size(victimLoc)(2);


certainty = 0.9; 
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
			    probx=certainty;
			  else
			    probx=(1-certainty)/(a1StateSpace-1);%5 is the other nodes that it will be written except itself 
			  end 
              
			  if (z1 == network(z,a3))
			    probz=certainty;
			  else
			    probz=(1-certainty)/(a2StateSpace-1);
			  end
	     
	     		  %victimLocState = 6; 
		  %dangerLocState = 3;
		  
		  %strcmp(agent2Actions{a2},'extract_victim')
		  %agent1Loc = {'a','b', 'c','d','e','f','g','h','i','j'};
		  %agent2Loc = {'a','b', 'c','d','e','f','g','h','i','j'};
%  		  dangerLoc = {'c','n'};%n means no danger
%  		  victimLoc = {'f','n'};%n means no victim 
%  
%  		  agent1Actions     = {'right','left','up','down','stop','clear_danger'};
%  		  agent3Actions     = {'right','left','up','down','stop','extract_victim'};
%  
%  		  agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
%  		  agent3Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
%!strcmp(agent1Actions{a1},'clear_danger')

%strcmp(agent3Actions{a3},'extract_victim')

			  if (x== dangerLocState && k==1 && a1==6 && k1==2)
			    probd=certainty;
			  elseif (x== dangerLocState && k==1 && a1<6 && k1==k)
			    probd=certainty;
			  elseif (x== dangerLocState && k==2 && k1==k)
			    probd=certainty;
			  elseif (x~= dangerLocState && k==2 &&  a1<6 && k1==k)
			    probd=certainty;
			  elseif (x~= dangerLocState && k1==k)
			    probd=certainty;
			  else
			    probd=1-certainty;
			  end 
                            
                            
			  if (z== victimLocState && w==1 && a3==6 && w1==2 )
			    probv=certainty;
			  elseif (z== victimLocState && w==1 && a3<6 && w1==w )
			    probv=certainty;
			  elseif (z== victimLocState && w==2 && w1==w )
			    probv=certainty;
			  elseif (z~= victimLocState && a3<6 && w1==w && w==2)
			    probv=certainty;
			  elseif (z~= victimLocState && w1==w )
			    probv=certainty;
			  else 
			    probv=1-certainty;
			  end                
			   
	     
%  			  if (x== dangerLocState && strcmp(dangerLoc{k},'c') && strcmp(agent1Actions{a1},'clear_danger') && strcmp(dangerLoc{k1},'n'))
%  			    probd=certainty;
%  			  elseif (x== dangerLocState && strcmp(dangerLoc{k},'c') && a1<6 && k1==k)
%  			    probd=certainty;
%  			  elseif (x== dangerLocState && strcmp(dangerLoc{k},'n') && k1==k)
%  			    probd=certainty;
%  			  elseif (x~= dangerLocState && strcmp(dangerLoc{k},'n') &&  a1<6 && k1==k)
%  			    probd=certainty;
%  			  elseif (x~= dangerLocState && k1==k)
%  			    probd=certainty;
%  			  else
%  			    probd=1-certainty;
%  			  end 
%                              
%                              
%  			  if (z== victimLocState && strcmp(victimLoc{w},'f') && strcmp(agent3Actions{a3},'extract_victim') && strcmp(victimLoc{w},'n'))
%  			    probv=certainty;
%  			  elseif (z== victimLocState && strcmp(victimLoc{w},'f') && a3<6 && w1==w )
%  			    probv=certainty;
%  			  elseif (z== victimLocState && strcmp(victimLoc{w},'n') && w1==w )
%  			    probv=certainty;
%  			  elseif (z~= victimLocState && a3<6 && w1==w && strcmp(victimLoc{w},'n'))
%  			    probv=certainty;
%  			  elseif (z~= victimLocState && w1==w )
%  			    probv=certainty;
%  			  else 
%  			    probv=1-certainty;
%  			  end                
			   
			   
			    uniProb1= probx*probz*probd*probv;
			    sum = sum + uniProb1;

			    fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %e',agent1Actions{a1},agent3Actions{a3},agent1Loc{x},agent2Loc{z},victimLoc{w},dangerLoc{k},agent1Loc{x1},agent2Loc{z1},victimLoc{w1},dangerLoc{k1},uniProb1);
			    
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

% How many observations:
a1ObservationSpace = size(agent1Observation)(2);
a2ObservationSpace = size(agent3Observation)(2);

obsCertainty =0.9;

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

		  
%  		  if(x==victimLocState && strcmp(victimLoc{w},'f') && strcmp(agent1Observation{o1},'vic_noDan')) 
%  		    probO1= obsCertainty;
%  		  elseif(x==victimLocState && strcmp(victimLoc{w},'n') && strcmp(agent1Observation{o1},'noVic_noDan'))
%  		     probO1= obsCertainty;
%  		  elseif ( x==dangerLocState && strcmp(dangerLoc{k},'c') && strcmp(agent1Observation{o1},'noVic_dan'))
%  		     probO1= obsCertainty;
%  		  elseif ( x==dangerLocState && strcmp(dangerLoc{k},'n') && strcmp(agent1Observation{o1},'noVic_noDan'))
%  		     probO1= obsCertainty;
%  		  elseif (x~=dangerLocState && x~=victimLocState && strcmp(agent1Observation{o1},'noVic_noDan'))
%  		      probO1= obsCertainty;
%  		  else 
%  		     probO1= (1-obsCertainty)/(a1ObservationSpace-1);
%  		  end 
%  
%  		  if(z==victimLocState && strcmp(victimLoc{w},'f') && strcmp(agent3Observation{o3},'vic_noDan'))
%  		    probO3= obsCertainty;
%  		  elseif(z==victimLocState && strcmp(victimLoc{w},'n') && strcmp(agent3Observation{o3},'noVic_noDan'))
%  		     probO3= obsCertainty;
%  		  elseif ( z==dangerLocState && strcmp(dangerLoc{k},'c') && strcmp(agent3Observation{o3},'noVic_dan'))
%  		     probO3= obsCertainty;
%  		  elseif ( z==dangerLocState && strcmp(dangerLoc{k},'n') && strcmp(agent3Observation{o3},'noVic_noDan'))
%  		     probO3= obsCertainty;
%  		  elseif (z~=dangerLocState && z~=victimLocState && strcmp(agent3Observation{o3},'noVic_noDan'))
%  		      probO3= obsCertainty;
%  		  else 
%  		     probO3= (1-obsCertainty)/(a2ObservationSpace-1);
%  		  end 
%  		  
		    if(x==7 && w==1 && o1 ==1)
		    probO1= obsCertainty;
		  elseif(x==7 && w==2 && o1 ==3)
		     probO1= obsCertainty;
		  elseif ( x==3 && k==1 && o1==2)
		     probO1= obsCertainty;
		  elseif ( x==3 && k==2 && o1==3)
		     probO1= obsCertainty;
		  elseif (x~=3 && x~=7 && o1==3)
		      probO1= obsCertainty;
		  else 
		     probO1= (1-obsCertainty)/(a1ObservationSpace-1);%2 is the other options of the observations 
		  end 

		  if(z==7 && w==1 && o3 ==1)
		    probO3= obsCertainty;
		  elseif(z==7 && w==2 && o3 ==3)
		     probO3= obsCertainty;
		  elseif ( z==3 && k==1 && o3==2)
		     probO3= obsCertainty;
		  elseif ( z==3 && k==2 && o3==3)
		     probO3= obsCertainty;
		  elseif (z~=3 && z~=7 && o3==3)
		      probO3= obsCertainty;
		  else 
		     probO3= (1-obsCertainty)/(a2ObservationSpace-1);
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
                fprintf(fid,'\nR: %s right : %s_d_%s_c : * :  * : -50', agent1Actions{a1}, agent1Loc{x},victimLoc{v});
                fprintf(fid,'\nR: %s up : %s_b_%s_c : * :  * : -50', agent1Actions{a1}, agent1Loc{x},victimLoc{v});
              end
	  end 
      end 

%  %  %----------------- penality for  robot clears danger and there is no danger------------------------- 

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
%                  fprintf(fid,'\nR: %s %s : c_%s_%s_c : * :  * : -50', agent1Actions{a1},agent3Actions{a3}, agent2Loc{z}, victimLoc{v});
%                 end
%  	    end
%           end 
%      end 
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
%  for a1=1:length(agent1Actions)
%        for x=1:length(agent1Loc)
%  	 for z=1:length(agent2Loc)
%              for d=1:length(dangerLoc)
%  	      if(z~=6)
%                  fprintf(fid,'\nR: %s extract_victim : %s_%s_f_%s : * :  * : -50', agent1Actions{a1}, agent1Loc{x}, agent2Loc{z}, dangerLoc{d});
%                 end
%  	    end
%            end 
%        end 
%    end 

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
      fprintf(fid,'\nR:  clear_danger %s : c_%s_%s_c :  * : * : 180',agent3Actions{a3}, agent2Loc{z}, victimLoc{v});
    end
  end 
end

 
%--------------- Extracting a victim is highly rewarded--------------------
for x=1:length(agent1Loc)
   for a1=1:length(agent1Actions)
	for k=1:length(dangerLoc)
	  fprintf(fid,'\nR:  %s extract_victim : %s_f_f_%s : * : * : 180', agent1Actions{a1},agent1Loc{x},dangerLoc{k});
	end
    end
end 




fprintf(fid,'\n');

fclose(fid);
