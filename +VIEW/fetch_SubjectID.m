function SubjectID = fetch_SubjectID(handles)

SubjectID = get(handles.edit_SubjectID,'String');
if isempty(SubjectID)
    error('SubjectID:Empty','SubjectID is empty')
end

end % function
