function JoystickStreamLoop( ~, ~, handles )

data = joymex2('query',0);

% Scale data to screen
Xraw = double(data.axes(1));
Yraw = double(data.axes(2));

% Joystick scale correction
X_min = -30045;
X_max = 0;

Y_min = -21108;
Y_max = 28427;

% value [0..1] => [X_min..X_max]
Xcal = (Xraw - X_min) / (X_max - X_min);
Ycal = (Yraw - Y_min) / (Y_max - Y_min);

fprintf('%s - Xraw/Xcal : %6d %+.3f - Yraw/Ycal : %6d %+.3f \n', datestr(now), Xraw, Xcal, Yraw, Ycal )

cla(handles.axes_Joystick)
hold(handles.axes_Joystick,'on')
plot(handles.axes_Joystick, 2, Xcal, 'rx')
plot(handles.axes_Joystick, 1, Ycal, 'kx')
GUI.VIEW.setAxesJoystickStream( handles ); % wrapper, because used several times

end % function
