function [options_no] = options_1x3( h )
  
options_no = 0;
 
   switch h
    case 1
      options_no= 2;
    case 2
      options_no= 3;
    case 3
      options_no= 2;
    case 8%danger
      options_no=2;
    case 9%victim
      options_no=2;
    end 
 
end
