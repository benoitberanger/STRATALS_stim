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

p.nBlock          = 3;       % for EACH hand
p.durRestBlock    = [10 10];  % [min max] in second, for the jitter
p.nTrialPerBlock  = 1;       % second

p.durBlockProduce = 5;       % second

switch OperationMode
    case 'Acquisition'
    case 'FastDebug'
        p.nBlock          = 2;       % for EACH hand
        p.durRestBlock    = [1 1];  % [min max] in second, for the jitter
        p.nTrialPerBlock  = 1;       % second
        
        p.durBlockProduce = 2;       % second
    case 'RealisticDebug'
        p.nBlock          = 1;       % for EACH hand
end


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );

p.Text.Size          = 0.2;           % Size_px = ScreenY_px * Size
p.Text.color_Active  = [255 255 255]; % [R G B a], from 0 to 255
p.Text.color_Passive = [000 000 000]; % [R G B a], from 0 to 255
p.Text.Position      = [0.50 0.50];   % Position_px = [ScreenX_px ScreenY_px] .* Position


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

% Randomize Left vs Right
blockOrder = repmat([1 2], [1 p.nBlock]);
if rand > 0.5, blockOrder = circshift(blockOrder,1); end

% Randomize durRestBlock
durRestBlock = linspace( p.durRestBlock(1), p.durRestBlock(2), p.nBlock*2 );

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'iBlock', 'iTrial', 'side'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

iTrial = 0;
for iBlock = 1 : p.nBlock * 2
    
    switch blockOrder(iBlock)
        
        case 1
            
            EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) iBlock iTrial ''})
            
            for n = 1 : p.nTrialPerBlock
                iTrial = iTrial + 1;
                EP.AddPlanning({ 'Trial_L_Produce' NextOnset(EP) p.durBlockProduce iBlock iTrial 'Left'})
            end
            
        case 2
            
            EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) iBlock iTrial ''})
            
            for n = 1 : p.nTrialPerBlock
                iTrial = iTrial + 1;
                EP.AddPlanning({ 'Trial_R_Produce' NextOnset(EP) p.durBlockProduce iBlock iTrial 'Right'})
            end
            
    end
    
end

EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) 0 0 ''})

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));

EP.BuildGraph();

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
