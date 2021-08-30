function setAxesJoystickStream( handles )

hold(handles.axes_Joystick, 'on')
plot(handles.axes_Joystick, [0 3], [0 0], 'k:') % hline
plot(handles.axes_Joystick, [0 3], [1 1], 'k:') % hline
xlim(handles.axes_Joystick, [0 3]);
ylim(handles.axes_Joystick, [-0.2 1.2]);
xticks(handles.axes_Joystick,[1 2])
xticklabels(handles.axes_Joystick,{'L' 'R'})
yticks(handles.axes_Joystick,[0 1])

end % function
