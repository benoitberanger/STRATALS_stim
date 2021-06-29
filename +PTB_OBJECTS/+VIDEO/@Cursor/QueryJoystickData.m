function QueryJoystickData( self )

data = joymex2('query',0);

% Scale data to screen
self.X = double(data.axes(1));
self.Y = double(data.axes(2));

% Joystick scale correction
X_min = -32768;
X_max = 0;

Y_min = -32768;
Y_max = 11745;

% value [0..1] => [X_min..X_max]
self.value_Left  = (self.Y - Y_min) / (Y_max - Y_min);
self.value_Right = (self.X - X_min) / (X_max - X_min);

end % function
