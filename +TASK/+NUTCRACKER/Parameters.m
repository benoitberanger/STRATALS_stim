function [ EP, TaskParam ] = Parameters()
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.OperationMode = 'Acquisition';
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

switch S.OperationMode
    case 'Acquisition'
    case 'FastDebug'
        p.nBlock          = 1;       % for EACH hand
        p.durRestBlock    = [2 3]; % [min max] in second, for the jitter
        p.nTrialPerBlock  = 2;       % second
    case 'RealisticDebug'
        p.nBlock          = 1;       % for EACH hand
        p.durRestBlock    = [10 15]; % [min max] in second, for the jitter
        p.nTrialPerBlock  = 4;       % second
end


%% Graphics



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
