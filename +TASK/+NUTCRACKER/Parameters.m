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

p.nBlock          = 5;       % for EACH hand
p.durRestBlock    = [10 15]; % [min max] in second, for the jitter
p.nTrialPerBlock  = 4;       % second

p.durBlockProduce = 2;       % second ARBITRARY => subject dependent
p.durBlockHold    = 4;       % second
p.durBlockRest    = 2;       % second

p.thresholdRT     = 0.1;     % from 0 to 1 => cursor value to define RT

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

p.Hand.file          = 'hand.png';    % files have to be in 'img\'
p.Hand.autocrop      = 1;             % auto-crop
p.Hand.invert        = 1;             % useful when the image is black instead of white
p.Hand.FWHM          = 10;            % px : kernel size for smoothing the image
p.Hand.pos_Left      = 0.45;
p.Hand.pos_Right     = 0.55;
p.Hand.pos_Y         = 0.90;
p.Hand.scale         = 0.10;          %  Size_px = ScreenX_px * scale
p.Hand.color_Active  = [000 128 000]; % for ProduceForce & Hold
p.Hand.color_Passive = [025 025 025]; % wont be used


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
                EP.AddPlanning({ 'Trial_L_Hold'    NextOnset(EP) p.durBlockHold    iBlock iTrial 'Left'})
                EP.AddPlanning({ 'Trial_L_Rest'    NextOnset(EP) p.durBlockRest    iBlock iTrial 'Left'})
            end
            
        case 2
            
            EP.AddPlanning({ 'BlockRest' NextOnset(EP) durRestBlock(iBlock) iBlock iTrial ''})
            
            for n = 1 : p.nTrialPerBlock
                iTrial = iTrial + 1;
                EP.AddPlanning({ 'Trial_R_Produce' NextOnset(EP) p.durBlockProduce iBlock iTrial 'Right'})
                EP.AddPlanning({ 'Trial_R_Hold'    NextOnset(EP) p.durBlockHold    iBlock iTrial 'Right'})
                EP.AddPlanning({ 'Trial_R_Rest'    NextOnset(EP) p.durBlockRest    iBlock iTrial 'Right'})
            end
            
    end
    
end

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
