function uipanel_Device(hObject, eventdata)
handles = guidata(hObject);

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_nutcracker'
        handles.uipanel_Joystick.Visible = 'On';
    case 'radiobutton_mouse'
        handles.uipanel_Joystick.Visible = 'Off';
        GUI.CONTROLLER.stopJoystickStream( handles )
end

end % function
