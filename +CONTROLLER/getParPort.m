function ParPort = getParPort( hObject )
handles = guidata( hObject );

switch get(handles.checkbox_ParPort, 'Value')
    case 1
        ParPort = 'On';
    case 0
        ParPort = 'Off';
    otherwise
        warning('Error in ParPort selection')
end

end % function
