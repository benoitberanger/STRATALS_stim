function QueryJoystickData( self )

data = joymex2('query',0);

% Scale data to screen
self.X = double(data.axes(1));
self.Y = double(data.axes(2));

% Joystick scale correction
data = nutcracker_raw_minmax();

% value [0..1] => [X_min..X_max]
self.value_Left  = (self.Y - data.Y_min) / (self.factor_Left  * (data.Y_max - data.Y_min) );
self.value_Right = (self.X - data.X_min) / (self.factor_Right * (data.X_max - data.X_min) );

end % function
