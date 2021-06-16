function [ EP, TaskParam ] = Parameters( OperationMode )
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Timings

p.nBlock          = 6;       % for EACH hand
p.durRestBlock    = [10 15]; % [min max] in second, for the jitter
p.nTrialPerBlock  = 4;       % second

p.durBlockHold    = 4;       % second
p.durBlockRest    = 2;       % second
p.durBlockProduce = 1;       % second

switch OperationMode
    case 'Acquisition'
    case 'FastDebug'
        p.nBlock          = 1;       % for EACH hand
        p.durRestBlock    = [2 3];   % [min max] in second, for the jitter
        p.nTrialPerBlock  = 2;       % second
    case 'RealisticDebug'
        p.nBlock          = 1;       % for EACH hand
        p.durRestBlock    = [10 15]; % [min max] in second, for the jitter
        p.nTrialPerBlock  = 4;       % second
end


%% Graphics

p.FixationCross.Size     = 0.10;          %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;          % Width_px =    Size_px * Width
p.FixationCross.Color    = [000 000 000]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];   % Position_px = [ScreenX_px ScreenY_px] .* Position

p.Target.Size          = 0.40;          %  Size_px = ScreenX_px * Size
p.Target.Width         = 0.05;          % Width_px =    Size_px * Width
p.Target.Color         = [255 255 255]; % [R G B], from 0 to 255
p.Target.pos_Left      = 0.25;          % always a ratio from the corresponding dimension
p.Target.pos_Right     = 0.75;
p.Target.pos_Low       = 0.75;
p.Target.pos_High      = 0.25;
p.Target.color_Active  = [000 255 000]; % for ProduceForce & Hold
p.Target.color_Passive = [255 000 000]; % for Rest

p.Cursor.Size          = p.Target.Size  * 0.95;
p.Cursor.Width         = p.Target.Width * 0.90;
p.Cursor.pos_Left      = p.Target.pos_Left;
p.Cursor.pos_Right     = p.Target.pos_Right;
p.Cursor.pos_Low       = p.Target.pos_Low;
p.Cursor.pos_High      = p.Target.pos_High;
p.Cursor.color_Active  = [255 255 255]; % for ProduceForce & Hold
p.Cursor.color_Passive = [000 000 000]; % wont be used


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

% Randomize durRestBlock
durRestBlock   = linspace( p.durRestBlock(1), p.durRestBlock(2), p.nBlock );
durRestBlock_L = Shuffle(durRestBlock);
durRestBlock_R = Shuffle(durRestBlock);

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

for evt = 1 : p.nBlock
    
    EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock_L(evt) })
    
    for n = 1 : p.nTrialPerBlock
        EP.AddPlanning({ 'Trial_L_Produce' NextOnset(EP) p.durBlockProduce })
        EP.AddPlanning({ 'Trial_L_Hold'    NextOnset(EP) p.durBlockHold    })
        EP.AddPlanning({ 'Trial_L_Rest'    NextOnset(EP) p.durBlockRest    })
    end
    
    EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock_R(evt) })
    
    for n = 1 : p.nTrialPerBlock
        EP.AddPlanning({ 'Trial_R_Produce' NextOnset(EP) p.durBlockProduce })
        EP.AddPlanning({ 'Trial_R_Hold'    NextOnset(EP) p.durBlockHold    })
        EP.AddPlanning({ 'Trial_R_Rest'    NextOnset(EP) p.durBlockRest    })
    end
    
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargout < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot();
    
end


%% Save

TaskParam = p;

S.EP        = EP;
S.TaskParam = TaskParam;


end % function
