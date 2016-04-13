% Description 
% this function will return the time it will take considering the number of the actual steps (hidden nodes) 
% the code is not yet fainalized, it might have some bugs. 
% Hend Al-Tair hend.altair@kustar.ac.ae

function [time] = timeFun(currentLocation,nextLocation)
% steps is a materix that contains 12 (number of nodes rows) 12 (number of nodes as columns)
% the nodes:              a   b   c   d   e   f   g   h   i   j   k   l 
% represented by numbers: 1   2   3   4   5   6   7   8   9   10  11  12 
% the time then will be multiplied by the number of steps from this function 

   steps=[0 1 3 4 5 7 11 13 14 15 22 23;1 0 2 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0 0 0];


  time= time; 
  
end
