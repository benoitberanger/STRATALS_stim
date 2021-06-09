function Core( hObject, ~ )
% This is the main program, calling the different tasks and routines,
% accoding to the paramterts defined in the GUI


%% Retrieve GUI data
% I prefere to do it here, once and for all.

handles = guidata( hObject );


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

Task = CONTROLLER.getTask( hObject );
S.Task = Task;


%% Save mode selection

SaveMode = CONTROLLER.getSaveMode( handles );
S.SaveMode = SaveMode;


%% Device mode selection

Device = CONTROLLER.getDevice( handles );
S.Device = Device;


%% Mode selection

OperationMode = CONTROLLER.getOperationMode( handles );
S.OperationMode = OperationMode;


%% Subject ID & Run number

[ SubjectID, ~, dirpath_SubjectID ] = CONTROLLER.getSubjectID( handles );

if SaveMode && strcmp(OperationMode,'Acquisition')
    
    if ~exist(dirpath_SubjectID, 'dir')
        mkdir(dirpath_SubjectID);
    end
    
end

DataFile_noRun = sprintf('%s_%s', SubjectID, Task );

RunNumber = MODEL.getRunNumber( DataFile_noRun );

DataFile     = sprintf('%s%s_%s_%s_run%0.2d', dirpath_SubjectID, S.TimeStampFile, SubjectID, Task, RunNumber );
DataFileName = sprintf(  '%s_%s_%s_run%0.2d',                    S.TimeStampFile, SubjectID, Task, RunNumber );

S.SubjectID     = SubjectID;
S.RunNumber     = RunNumber;
S.DataPath      = dirpath_SubjectID;
S.DataFile      = DataFile;
S.DataFileName  = DataFileName;


%% Quick warning

% Acquisition => save data
if strcmp(OperationMode,'Acquisition') && SaveMode
    warning('BIOMRI_CADA:DataShouldBeSaved','\n\n In acquisition mode, data should be saved \n')
end


%% Parallel port ?

ParPort = CONTROLLER.getParPort( handles );
S.ParPort = ParPort;
S.ParPortMessages = PARPORT.Prepare();


%% Eyelink ?

EyelinkMode = CONTROLLER.getEyelinkMode( handles );


if EyelinkMode
    
    % 'Eyelink.m' exists ?
    assert( ~isempty(which('Eyelink.m')), 'no ''Eyelink.m'' detected in the path')
    
    % Save mode ?
    assert( SaveMode ,' \n ---> Save mode should be turned ON when using Eyelink <--- \n ')
        
    % Eyelink connected ?
    Eyelink.IsConnected
    
    % Generate the Eyelink filename
    eyelink_max_finename = 8;                                          % Eyelink filename must be 8 char or less...
    available_char = ['a':'z' 'A':'Z' '0':'9'];                        % This is all characters available (N=62)
    name_num = randi(length(available_char),[1 eyelink_max_finename]); % Pick 8 numbers, from 1 to N=62 (same char can be picked twice)
    name_str = available_char(name_num);                               % Convert the 8 numbers into char
    
    % Save it
    S.EyelinkFile = name_str;
    
end


%% Security : NEVER overwrite a file
% If erasing a file is needed, we need to do it manually

if SaveMode && strcmp(OperationMode,'Acquisition')
    
    assert( ~exist([DataFile '.mat'],'file'), ' \n ---> \n The file %s.mat already exists .  <--- \n \n', DataFile );
    
end


%% ScreenID & ScreenMode selection

S.ScreenID     = CONTROLLER.getScreenID    ( handles );
S.WindowedMode = CONTROLLER.getWindowedMode( handles );


%% Open PTB window & sound, if need
% comment/uncomment as needed

PTB_ENGINE.VIDEO.Parameters(); % <= here is all paramters
PTB_ENGINE.VIDEO.OpenWindow(); % this opens the windows and setup the drawings according the the paramters above

