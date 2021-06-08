function SaveMode = getSaveMode( hObject )
handles = guidata( hObject );

switch get(get(handles.uipanel_SaveMode,'SelectedObject'),'Tag')
    case 'radiobutton_SaveData'
        SaveMode = 'On';
    case 'radiobutton_NoSave'
        SaveMode = 'Off';
    otherwise
        warning('Error in SaveMode selection')
end

end % function
