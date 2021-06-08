function Core(hObject, ~)
% This is the main program, calling the different tasks and routines,
% accoding to the paramterts defined in the GUI


%% Clean the environment

clc
sca
rng('default')
rng('shuffle')


%% Initialize the main structure

% NOTES : Here I made the choice of using a "global" variable, because it
% simplifies a lot all the functions. It allows retrieve of the variable
% everywhere, and make lighter the input paramters.

global S
S                 = struct; % S is the main structure, containing everything usefull, and used everywhere
S.TimeStampSimple = datestr(now, 'yyyy-mm-dd HH:MM'); % readable
S.TimeStampFile   = datestr(now, 30                ); % yyyymmddTHHMMSS : to sort automatically by time of creation


%% Task selection

Task = CONTROLLER.getTask(hObject);
S.Task = Task;


%% Save mode selection

SaveMode = CONTROLLER.getSaveMode(hObject);
S.SaveMode = SaveMode;


%% Device mode selection

Device = CONTROLLER.getDevice(hObject);
S.Device = Device;


%% Mode selection

OperationMode = CONTROLLER.getOperationMode(hObject);
S.OperationMode = OperationMode;


%% Subject ID & Run number

[ SubjectID, ~, dirpath_SubjectID ] = CONTROLLER.getSubjectID(guidata(hObject));

if strcmp(SaveMode,'On') && strcmp(OperationMode,'Acquisition')
    
    if ~exist(dirpath_SubjectID, 'dir')
        mkdir(dirpath_SubjectID);
    end
    
end

DataFile_noRun = sprintf('%s_%s', SubjectID, Task );

RunNumber = MODEL.getRunNumber(DataFile_noRun);

DataFile     = sprintf('%s%s_%s_%s_run%0.2d', dirpath_SubjectID, S.TimeStampFile, SubjectID, Task, RunNumber );
DataFileName = sprintf(  '%s_%s_%s_run%0.2d',                    S.TimeStampFile, SubjectID, Task, RunNumber );

S.SubjectID     = SubjectID;
S.RunNumber     = RunNumber;
S.DataPath      = dirpath_SubjectID;
S.DataFile      = DataFile;
S.DataFileName  = DataFileName;


%% Quick warning

% Acquisition => save data
if strcmp(OperationMode,'Acquisition') && strcmp(SaveMode, 'Off')
    warning('BIOMRI_CADA:DataShouldBeSaved','\n\n In acquisition mode, data should be saved \n')
end

