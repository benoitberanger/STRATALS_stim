function QueryJoystickData( self )

data = joymex2('query',0);

% Scale data to screen
self.X = double(data.axes(1))/2^15;
self.Y = double(data.axes(2))/2^15;

% Joystick scale correction
% if X > 0
%     X = X * 2^15/28500;
% end
% if Y < 0
%     Y = Y * 2^15/30100;
% end

end % function
