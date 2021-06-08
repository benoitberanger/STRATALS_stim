function Device = getDevice( hObject )
handles = guidata( hObject );

switch get(get(handles.uipanel_Device,'SelectedObject'),'Tag')
    case 'radiobutton_nutcracker'
        Device = 'Nutcracker';
    case 'radiobutton_mouse'
        Device = 'Mouse';
    otherwise
        warning('Error in Device selection')
end

end % function
