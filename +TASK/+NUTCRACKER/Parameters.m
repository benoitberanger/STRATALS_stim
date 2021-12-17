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

p.nBlock          = 5;                 % for EACH hand
p.durRestBlock    = [10 15];           % [min max] in second, for the jitter
p.valueModulator  = [20 40 60]/100;    % ratio from Fmax
p.nTrialPerBlock  = length(p.valueModulator);

p.durBlockProduce = 2;                 % second ARBITRARY => subject dependent
p.durBlockHold    = 4;                 % second
p.durBlockRest    = 2;                 % second

p.thresholdRT     = 0.1;               % from 0 to 1 => cursor value to define RT


switch OperationMode
    case 'Acquisition'
    case 'FastDebug'
        p.nBlock          = 1;         % for EACH hand
        p.durRestBlock    = [1 2];     % [min max] in second, for the jitter
        p.durBlockHold    = 1;         % second
        p.durBlockRest    = 1;         % second
    case 'RealisticDebug'
        p.nBlock          = 1;         % for EACH hand
end


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

% Randomize Left vs Right
while 1
    blockOrder = Shuffle([ ones(1,p.nBlock)*1 ones(1,p.nBlock)*2 ]);
    if ~any(diff(diff(blockOrder)) == 0)%  maximum 2 blocks in a row
        break
    end
end

% Randomize modulator values
modulator = zeros(p.nBlock * 2,p.nTrialPerBlock);
for iBlock = 1 : p.nBlock * 2
    if iBlock > 1
        while 1
            blk_mod = Shuffle(p.valueModulator);
            if blk_mod(1) ~= modulator(iBlock-1,end)
                modulator(iBlock,:) = blk_mod;
                break
            end
        end 
    else
        modulator(iBlock,:) = Shuffle(p.valueModulator);
    end
end

% Randomize durRestBlock
durRestBlock = linspace( p.durRestBlock(1), p.durRestBlock(2), p.nBlock*2 );

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'iBlock', 'iTrial', 'side', 'value'};
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
            
            EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) iBlock iTrial '' ''})
            
            for n = 1 : p.nTrialPerBlock
                iTrial = iTrial + 1;
                EP.AddPlanning({'Trial_L_Produce' NextOnset(EP) p.durBlockProduce iBlock iTrial 'Left' modulator(iBlock, n)})
                EP.AddPlanning({'Trial_L_Hold'    NextOnset(EP) p.durBlockHold    iBlock iTrial 'Left' modulator(iBlock, n)})
                EP.AddPlanning({'Trial_L_Rest'    NextOnset(EP) p.durBlockRest    iBlock iTrial 'Left' modulator(iBlock, n)})
            end
            
        case 2
            
            EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) iBlock iTrial '' ''})
            
            for n = 1 : p.nTrialPerBlock
                iTrial = iTrial + 1;
                EP.AddPlanning({'Trial_R_Produce' NextOnset(EP) p.durBlockProduce iBlock iTrial 'Right' modulator(iBlock, n)})
                EP.AddPlanning({'Trial_R_Hold'    NextOnset(EP) p.durBlockHold    iBlock iTrial 'Right' modulator(iBlock, n)})
                EP.AddPlanning({'Trial_R_Rest'    NextOnset(EP) p.durBlockRest    iBlock iTrial 'Right' modulator(iBlock, n)})
            end
            
    end
    
end

EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) 0 0 '' ''})

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
