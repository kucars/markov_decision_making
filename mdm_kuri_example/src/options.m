function [options_no] = options( h )
  
options_no = 0;
 
   switch h
    case 1
      options_no= 2;
    case 2
      options_no= 3;
    case 3
      options_no= 4;
    case 4
      options_no= 3;
    case 5
      options_no= 2;
    case 6
      options_no= 3;
    case 7
      options_no= 2;
    case 8%danger
      options_no=2;
    case 9%victim
      options_no=2;
    end 
 
end
