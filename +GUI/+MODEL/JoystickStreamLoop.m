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

fprintf('%s - Xraw/Xcal : %6d %0.3f - Yraw/Ycal : %6d %0.3f \n', datestr(now), Xraw, Xcal, Yraw, Ycal )

cla(handles.axes_Joystick)
hold(handles.axes_Joystick,'on')
handles.axes_Joystick.XLim = [0 3];
handles.axes_Joystick.YLim = [-0.5 1.5];
plot(handles.axes_Joystick, 2, Xcal, 'rx')
plot(handles.axes_Joystick, 1, Ycal, 'kx')
plot(handles.axes_Joystick, [0 3], [0 0], 'k:') % hline
plot(handles.axes_Joystick, [0 3], [1 1], 'k:') % hline
xticks(handles.axes_Joystick,[1 2])
xticklabels(handles.axes_Joystick,{'L' 'R'})
yticks(handles.axes_Joystick,[0 1])

end % function
