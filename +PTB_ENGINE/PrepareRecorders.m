function [ ER, KL, SR ] = PrepareRecorders( EP )
global S


%% Prepare event record
% This object will record the real timings of stim events, for later
% comparaison with EP (EventPlaning) the expected onsets.

% Create
ER = EventRecorder( EP.Header , EP.EventCount );

% Prepare
ER.AddStartTime( 'StartTime' , 0 );

S.ER = ER;


%% Sample recorder
% This will record numeric data, usually 1 line for each frame

SR = SampleRecorder( { 'time (s)', 'X', 'Y', 'value_Left', 'value_Right' } , round(EP.Data{end,2}*S.PTB.Video.FPS*1.20) ); % ( expected duration of the task +20% )

S.SR = SR;


%% Prepare the keylogger, including MRI triggers
% This will record all keys using KbQueue* functions, for passive key
% logging

KbName('UnifyKeyNames');

KL = KbLogger( ...
    struct2array(S.Keybinds)         ,...
    KbName(struct2array(S.Keybinds)) );

% Start recording events
KL.Start();

S.KL = KL;


end % function
