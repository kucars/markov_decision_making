function [rewardedDistance] = energyRewardFun(currentLocation,nextLocation)%we don't need the whole state, just the location of x or z ,,,We don't need the network
  rewardedDistance=0;
  reward =-10; 
  distance=0; 
  
    %for x=1:12
      %if(network(currentLocation,x)~=currentLocation)%it means that it can move to another node, now we need to calculate the distances 
      %a=1,b=2,c=3,d=4,e=5,f=6. g=7 h=8, i=9, j=10, k=11, l=12

	switch currentLocation
	  case 1
	    if (nextLocation==2)
	      distance=1;
	    end 
	  case 2
	    if (nextLocation==1)
	      distance=1;
	    elseif(nextLocation==3)
	      distance=2;
	    elseif(nextLocation==12)
	      distance=3;
	    end 
	  case 3
	    if (nextLocation==2)
	      distance=2;
	    elseif(nextLocation==4)
	      distance=2;
	    elseif(nextLocation==10)
	      distance=2;
	    end 
	  case 4
	    if (nextLocation==5)
	      distance=1;
	    elseif(nextLocation==3)
	      distance=1;
	    end 
	  case 5
	    if (nextLocation==4)
	      distance=1;
	    elseif(nextLocation==6)
	      distance=2;
	    end 
	  case 6
	    if (nextLocation==5)
	      distance=2;
	    elseif(nextLocation==7)
	      distance=4;
	    end 
	  case 7
	    if (nextLocation==6)
	      distance=4;
	    elseif(nextLocation==8)
	      distance=2;
	    end 
	  case 8
	    if (nextLocation==7)
	      distance=2;
	    elseif(nextLocation==9)
	      distance=1;
	    end 
	  case 9
	    if (nextLocation==8)
	      distance=1;
	    elseif(nextLocation==10)
	      distance=1;
	    end 
	  case 10
	    if (nextLocation==9)
	      distance=1;
	    elseif(nextLocation==3)
	      distance=2;
	    end 
	  case 11
	    if (nextLocation==12)
	      distance=1;
	    end 
	  case 12 
	    if (nextLocation==11)
	      distance=1;
	    elseif(nextLocation==2)
	      distance=3;
	    end 
	
	end%end switch
      %end%end if
   % end%end for
  
  rewardedDistance=distance*reward;
  
end
