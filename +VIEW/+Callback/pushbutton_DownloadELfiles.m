function pushbutton_DownloadELfiles(hObject, ~)
handles = guidata(hObject);

SubjectID = VIEW.fetch_SubjectID(handles);

DataPath = [fileparts(pwd) filesep 'data' filesep SubjectID filesep];
el_file = [DataPath 'eyelink_files_to_download.txt'];

if ~exist(el_file,'file')
    error('File does not exists : %s', el_file)
end

Eyelink.downloadELfiles(DataPath)

end % function
