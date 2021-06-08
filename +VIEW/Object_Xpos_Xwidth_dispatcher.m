function obj = Object_Xpos_Xwidth_dispatcher( obj , vect , interWidth )

obj.vect  = vect; % relative proportions of each panel, from left to right

obj.interWidth = interWidth;
obj.vectLength = length(obj.vect);
obj.vectTotal  = sum(obj.vect);
obj.unitWidth  = ( 1 - (obj.interWidth*(obj.vectLength + 1)) ) / obj.vectTotal ;

obj.count  = 0;
obj.xpos   = @(count) obj.unitWidth*sum(obj.vect(1:count-1)) + obj.interWidth *(count);
obj.xwidth = @(count) obj.vect(count)*obj.unitWidth;

end % function
