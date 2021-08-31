function JoystickStreamLoop( ~, ~, handles )

data = joymex2('query',0);

% Scale data to screen
Xraw = double(data.axes(1));
Yraw = double(data.axes(2));

% Joystick scale correction
data = nutcracker_raw_minmax();

% value [0..1] => [X_min..X_max]
Xcal = (Xraw - data.X_min) / (data.X_max - data.X_min);
Ycal = (Yraw - data.Y_min) / (data.Y_max - data.Y_min);

fprintf('%s - Xraw/Xcal : %6d %+.3f - Yraw/Ycal : %6d %+.3f \n', datestr(now), Xraw, Xcal, Yraw, Ycal )

cla(handles.axes_Joystick)
hold(handles.axes_Joystick,'on')
plot(handles.axes_Joystick, 2, Xcal, 'rx')
plot(handles.axes_Joystick, 1, Ycal, 'bx')
GUI.VIEW.setAxesJoystickStream( handles ); % wrapper, because used several times

end % function
