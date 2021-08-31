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


%% Stop joystick display if running

GUI.CONTROLLER.stopJoystickStream( handles );


%% Initialize the main structure

% NOTES : Here I made the choice of using a "global" variable, because it
% simplifies a lot all the functions. It allows retrieve of the variable
% everywhere, and make lighter the input paramters.

global S
S                 = struct; % S is the main structure, containing everything usefull, and used everywhere
S.TimeStampSimple = datestr(now, 'yyyy-mm-dd HH:MM'); % readable
S.TimeStampFile   = datestr(now, 30                ); % yyyymmddTHHMMSS : to sort automatically by time of creation


%% Task selection

Task   = GUI.CONTROLLER.getTask( hObject );
S.Task = Task;


%% Save mode selection

SaveMode   = GUI.CONTROLLER.getSaveMode( handles );
S.SaveMode = SaveMode;


%% Mode selection

OperationMode   = GUI.CONTROLLER.getOperationMode( handles );
S.OperationMode = OperationMode;


%% Movie off/on

MovieMode   = GUI.CONTROLLER.getMovieMode( handles );
if MovieMode && ~(strcmp(OperationMode,'Acquisition') && SaveMode)
    MovieMode = 0;
    warning('Movie can only be savec with SaveMode=1 & OperationMode=''Acquisition''')
end

S.MovieMode = MovieMode;


%% Subject ID & Run number

[ SubjectID, ~, dirpath_SubjectID ] = GUI.CONTROLLER.getSubjectID( handles );

if SaveMode && strcmp(OperationMode,'Acquisition')
    
    if ~exist(dirpath_SubjectID, 'dir')
        mkdir(dirpath_SubjectID);
    end
    
end

DataFile_noRun  = sprintf('%s_%s', SubjectID, Task );
RunNumber       = GUI.MODEL.getRunNumber( DataFile_noRun );
DataFile        = sprintf('%s%s_%s_%s_run%0.2d', dirpath_SubjectID, S.TimeStampFile, SubjectID, Task, RunNumber );
DataFileName    = sprintf(  '%s_%s_%s_run%0.2d',                    S.TimeStampFile, SubjectID, Task, RunNumber );

S.SubjectID     = SubjectID;
S.RunNumber     = RunNumber;
S.DataPath      = dirpath_SubjectID;
S.DataFile      = DataFile;
S.DataFileName  = DataFileName;


%% Device mode selection

Device = GUI.CONTROLLER.getDevice( handles );
S.Device = Device;

switch Device
    case 'Nutcracker'
        joymex2('open',0);
end


%% Calibration values

[ calib_Left , calib_Right ] = GUI.CONTROLLER.getCalib(handles);
S.calib_Left  = calib_Left;
S.calib_Right = calib_Right;


%% Quick warning

% Acquisition => save data
if strcmp(OperationMode,'Acquisition') && ~SaveMode
    warning('In acquisition mode, data should be saved')
end


%% Parallel port ?

ParPort           = GUI.CONTROLLER.getParPort( handles );
S.ParPort         = ParPort;
S.ParPortMessages = PARPORT.Prepare();


%% Eyelink ?

EyelinkMode   = GUI.CONTROLLER.getEyelinkMode( handles );
S.EyelinkMode = EyelinkMode;

if EyelinkMode
    
    % 'Eyelink.m' exists ?
    assert( ~isempty(which('Eyelink.m')), 'no ''Eyelink.m'' detected in the path')
    
    % Save mode ?
    assert( SaveMode ,' \n ---> Save mode should be turned ON when using Eyelink <--- \n ')
    
    % Eyelink connected ?
    Eyelink.IsConnected();
    
    % Generate the Eyelink filename
    eyelink_max_finename = 8;                                                       % Eyelink filename must be 8 char or less...
    available_char        = ['a':'z' 'A':'Z' '0':'9'];                              % This is all characters available (N=62)
    name_num              = randi(length(available_char),[1 eyelink_max_finename]); % Pick 8 numbers, from 1 to N=62 (same char can be picked twice)
    name_str              = available_char(name_num);                               % Convert the 8 numbers into char
    
    % Save it
    S.EyelinkFile = name_str;
    
end


%% Security : NEVER overwrite a file
% If erasing a file is needed, we need to do it manually

if SaveMode && strcmp(OperationMode,'Acquisition')
    assert( ~exist([DataFile '.mat'],'file'), ' \n ---> \n The file %s.mat already exists .  <--- \n \n', DataFile );
end


%% ScreenID & ScreenMode selection

S.ScreenID     = GUI.CONTROLLER.getScreenID    ( handles );
S.WindowedMode = GUI.CONTROLLER.getWindowedMode( handles );


%% Open PTB window & sound, if need
% comment/uncomment as needed

PTB_ENGINE.VIDEO.Parameters(); % <= here is all paramters
PTB_ENGINE.VIDEO.OpenWindow(); % this opens the windows and setup the drawings according the the paramters above

% PTB_ENGINE.AUDIO.         Initialize(); % !!! This must be done once before !!!
% PTB_ENGINE.AUDIO.PLAYBACK.Parameters(); % <= here is all paramters
% PTB_ENGINE.AUDIO.PLAYBACK.OpenDevice(); % this opens the playback device (speakers/headphones) and setup according the the paramters above
% PTB_ENGINE.AUDIO.RECORD  .Parameters(); % <= here is all paramters
% PTB_ENGINE.AUDIO.RECORD  .OpenDevice(); % this opens the record device (microphone) and setup according the the paramters above

PTB_ENGINE.KEYBOARD.Parameters(); % <= here is all paramters


%% Everything is read, start Task

EchoStart(Task)

switch Task
    case 'Calibration'              % TASK.CALIBRATION.Parameters <= here is all paramters
        TASK.CALIBRATION.Runtime(); % execution of the task
    case 'Nutcracker'               % TASK.NUTCRACKER.Parameters <= here is all paramters
        TASK.NUTCRACKER.Runtime();  % execution of the task
    case 'EyelinkCalibration'
        Eyelink.Calibration(S.PTB.Video.wPtr);
        S.TaskData.ER.Data = {};
    otherwise
        error('Task ?')
end

EchoStop(Task)


%% Save the file on the fly, without any prcessing => just a security

save( fullfile(fileparts(pwd),'data','lastS.mat') , 'S' )


%% Stop PTB engine

% Video : comment/uncomment
sca;
Priority(0);

% Audio : comment/uncomment
% PsychPortAudio('Close');


%% Behavior stats computation
% Here "S" is a paramter, so in case we modify the stats computation,
% its easy to re-compute : load old file and call the function on it.

switch Task
    case 'Calibration'
        [ calib_Left, calib_Right ] = TASK.CALIBRATION.STATS.GetMax( S );
        S.calib_Left  = calib_Left;
        S.calib_Right = calib_Right;
        handles.edit_Calib_Left .String = num2str(calib_Left );
        handles.edit_Calib_Right.String = num2str(calib_Right);
    case 'Nutcracker'
        TASK.NUTCRACKER.STATS.Stability( S );
end


%% Generate SPM names onset durations

[ names , onsets , durations ] = TASK.SPMnod();


%% Save

if SaveMode && strcmp(OperationMode,'Acquisition')
    
    save( DataFile        , 'S', 'names', 'onsets', 'durations'); % complet file
    save([DataFile '_SPM']     , 'names', 'onsets', 'durations'); % light weight file with only the onsets for SPM
    
end


%% Send S and SPM n.o.d. to workspace

assignin('base', 'S'        , S        );
assignin('base', 'names'    , names    );
assignin('base', 'onsets'   , onsets   );
assignin('base', 'durations', durations);


%% MAIN : End recording of Eyelink

% Eyelink mode 'On' ?
if EyelinkMode
    
    % Stop recording and retrieve the file
    Eyelink.StopRecording( S.EyelinkFile )
    
end


%% Ready for another run

set(handles.text_LastFileNameAnnouncer, 'Visible', 'on')
set(handles.text_LastFileName         , 'Visible', 'on')
set(handles.text_LastFileName         , 'String' , DataFile(length(dirpath_SubjectID)+1:end))

WaitSecs(0.100);
pause(0.100);
fprintf('\n')
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n')
fprintf('    Ready for another run    \n')
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n')


%% Close joystick

switch Device
    case 'Nutcracker'
        clear joymex2
end


end % function
