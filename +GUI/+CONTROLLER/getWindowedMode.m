function [ WindowedMode ] = getWindowedMode( handles )

switch get(handles.checkbox_WindowedScreen,'Value')
    case 1
        WindowedMode = 1;
    case 0
        WindowedMode = 0;
    otherwise
        error('Error in WindowedMode selection')
end

end % function
