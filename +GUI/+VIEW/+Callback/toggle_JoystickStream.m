function toggle_JoystickStream(hObject, event)
handles = guidata(hObject);

switch event.Source.Value
    case 1
        
        try
            % Initialize joystick
            joymex2('open',0);
        catch err
            hObject.Value = 0;
            rethrow(err)
        end
        
        handles.timer = timer(...
            'StartDelay',     0         ,...
            'Period',         0.020     ,... % seconds
            'TimerFcn', {@GUI.MODEL.JoystickStreamLoop,handles},...
            'BusyMode',       'drop'    ,...  %'queue'
            'TasksToExecute', Inf       ,...
            'ExecutionMode', 'fixedRate');
        
        start(handles.timer);
        
        hObject.BackgroundColor = [0 0.5 0];
        
    case 0
        
        stop  ( handles.timer );
        delete( handles.timer );
        clear joymex2
        hObject.BackgroundColor = handles.buttonBGcolor;
        cla(handles.axes_Joystick)
        
end

guidata(hObject,handles);
end % function
