function stopJoystickStream( handles )

hObject = handles.toggle_Stream;
event.Source.Value = 0;
GUI.VIEW.Callback.toggle_JoystickStream(hObject, event);

end % function