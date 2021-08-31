function [ calib_Left , calib_Right ] = getCalib(handles)

calib_Left  = str2double( handles.edit_Calib_Left .String );
calib_Right = str2double( handles.edit_Calib_Right.String );

end % function
