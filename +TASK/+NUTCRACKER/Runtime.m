function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.NUTCRACKER.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    [ ER, KL, SR ] = PTB_ENGINE.PrepareRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.NUTCRACKER.PREPARE.FixationCross();
    TARGET        = TASK.NUTCRACKER.PREPARE.Target       ();
    CURSOR        = TASK.NUTCRACKER.PREPARE.Cursor       ();
    
    
    %% Shortcuts
    
    wPtr        = S.PTB.Video.wPtr;
    slack       = S.PTB.Video.slack;
    ESCAPE      = S.Keybinds.Stop_Escape;
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        % Shortcuts
        evt_name      = EP.Data{evt,1};
        evt_onset     = EP.Data{evt,2};
        evt_duration  = EP.Data{evt,3};
        if evt > 1, prev_duration = EP.Data{evt-1,3}; end
        
        % Logs
        fprintf('%s for %gs \n', evt_name, evt_duration)
        
        % Get 'side'
        split = strsplit(evt_name,'_');
        if length(split)>1
            switch split{2}
                case 'L'
                    side = 'Left';
                case 'R'
                    side = 'Right';
            end
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Fetch initialization data
                switch S.Device
                    case 'Nutcracker'
                    case 'Mouse'
                        SetMouse(CURSOR.pos_Left,CURSOR.pos_Low, S.ScreenID); % set mouse to arbitrary but known position
                        CURSOR.Update();
                end
                
                FIXATIONCROSS.Draw();
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                prev_onset    = StartTime;
                prev_duration = 0;
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = PTB_ENGINE.StopTimeEvent( StartTime, evt );
                
                
            case 'BlockRest' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                
                % Flip at the right moment
                desired_onset =  prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime []});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        [EXIT, StopTime] = PTB_ENGINE.CheckESCAPE(keyCode(ESCAPE), StartTime);
                        if EXIT, break, end
                    end
                    
                end % while
                
                
            case {'Trial_L_Produce', 'Trial_R_Produce'} % -----------------
                
                % Draw
                TARGET.Draw(side,'High','Active');
                CURSOR.Update();
                CURSOR.Draw(side);
                
                % Flip at the right moment
                desired_onset = prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime []});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                while 1
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        [EXIT, StopTime] = PTB_ENGINE.CheckESCAPE(keyCode(ESCAPE), StartTime);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw(side,'High','Active');
                    CURSOR.Update();
                    CURSOR.Draw(side);
                    
                    flip_onset = Screen('Flip', wPtr);
                    
                    if CURSOR.value >= 1 % cursor reached target
                        break;
                    end
                    
                end % while
                
                
            case {'Trial_L_Hold', 'Trial_R_Hold'} % -----------------------
                
                % Draw
                TARGET.Draw(side,'High','Active');
                CURSOR.Update();
                CURSOR.Draw(side);
                
                % Flip at the right moment
                desired_onset = prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime []});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        [EXIT, StopTime] = PTB_ENGINE.CheckESCAPE(keyCode(ESCAPE), StartTime);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw(side,'High','Active');
                    CURSOR.Update();
                    CURSOR.Draw(side);
                    
                    flip_onset = Screen('Flip', wPtr);
                    
                    
                end % while
                
                
            case {'Trial_L_Rest', 'Trial_R_Rest'} % -----------------------
                
                % Draw
                TARGET.Draw(side,'Low','Passive');
                CURSOR.Update();
                CURSOR.Draw(side);
                
                % Flip at the right moment
                desired_onset = prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime []});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        [EXIT, StopTime] = PTB_ENGINE.CheckESCAPE(keyCode(ESCAPE), StartTime);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw(side,'Low','Passive');
                    CURSOR.Update();
                    CURSOR.Draw(side);
                    
                    flip_onset = Screen('Flip', wPtr);
                    
                    
                end % while
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
    %% End of task execution stuff
    
    PTB_ENGINE.FinilizeRecorders( StartTime );
    
    % Save some values
    S.StartTime = StartTime;
    S.StopTime  = StopTime;
    
    % Close parallel port
    if S.ParPort, CloseParPort(); end
    
    % Diagnotic
    switch S.OperationMode
        case 'Acquisition'
        case 'FastDebug'
            plotDelay(EP,ER);
        case 'RealisticDebug'
            plotDelay(EP,ER);
    end
    
    
catch err
    
    sca;
    Priority(0);
    ShowCursor;
    
    switch S.Device
        case 'Nutcracker'
            clear joymex2
    end
    
    rethrow(err);
    
end % try

end % function
