function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.CALIBRATION.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.NUTCRACKER. PREPARE.FixationCross();
    CURSOR        = TASK.NUTCRACKER. PREPARE.Cursor       (); % here the object is used only for the device data query
    HAND          = TASK.NUTCRACKER. PREPARE.Hand         ();
    TEXT          = TASK.CALIBRATION.PREPARE.Text         ();
    
    
    %% Shortcuts
    
    ER          = S.ER;
    SR          = S.SR;
    Stability   = S.Stability;
    wPtr        = S.PTB.Video.wPtr;
    slack       = S.PTB.Video.slack;
    ESCAPE      = S.Keybinds.Stop_Escape;
    if S.MovieMode, moviePtr = S.moviePtr; end
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name      = EP.Data{evt,1};
        % evt_onset     = EP.Data{evt,2};
        evt_duration  = EP.Data{evt,3};
        block         = EP.Data{evt,4};
        trial         = EP.Data{evt,5};
        side          = EP.Data{evt,6};
        if (evt > 1) && (evt < nEvents)
            prev_duration = EP.Data{evt-1,3};
            switch side
                case 'Left'
                    side_num = -1;
                case 'Right'
                    side_num = +1;
            end
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Fetch initialization data
                switch S.Device
                    case 'Nutcracker'
                    case 'Mouse'
                        SetMouse(CURSOR.pos_X,CURSOR.pos_Low, S.ScreenID); % set mouse to starting position value = (0,0)
                        CURSOR.Update();
                end
                
                % Draw
                FIXATIONCROSS.Draw();
                HAND.Draw('Left' ,'Passive');
                HAND.Draw('Right','Passive');
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                prev_onset    = StartTime;
                prev_duration = 0;
                SR.AddSample([ 0 CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = PTB_ENGINE.StopTimeEvent( StartTime, evt );
                
                
            case 'BlockRest' % --------------------------------------------
                
                % Draw
                TEXT.Draw( sprintf( '%d', round(evt_duration) ), 'Passive' );
                HAND.Draw('Left' ,'Passive');
                HAND.Draw('Right','Passive');
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                
                % Flip at the right moment
                desired_onset =  prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                CURSOR.Update();
                SR.AddSample([ real_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + EP.Data{evt+1,2} - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    val = next_onset-secs;
                    if val < 0, val = 0; end % happens at the last iteration of the loop
                    TEXT.Draw( sprintf( '%d', round(val) ), 'Passive' );
                    HAND.Draw('Left' ,'Passive');
                    HAND.Draw('Right','Passive');
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    flip_onset = Screen('Flip', wPtr);
                    CURSOR.Update();
                    SR.AddSample([ flip_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                    
                end % while
                
                
            case {'Trial_L_Produce', 'Trial_R_Produce'} % -----------------
                
                % Logs
                fprintf('block=%d   trial=%d   side=%5s  \n', block, trial, side)
                
                % Draw
                TEXT.Draw( sprintf( '%d', round(evt_duration) ), 'Active' );
                switch side
                    case 'Left'
                        HAND.Draw('Left' ,'Active' );
                        HAND.Draw('Right','Passive');
                    case 'Right'
                        HAND.Draw('Left' ,'Passive');
                        HAND.Draw('Right','Active' );
                end
                CURSOR.Update();
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                
                % Flip at the right moment
                real_onset = Screen('Flip', wPtr);
                prev_onset = real_onset;
                SR.AddSample([ real_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                % Stability
                sample_start = SR.SampleCount;
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + EP.Data{evt+1,2} - slack;
                while secs < next_onset
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    val = next_onset-secs;
                    if val < 0, val = 0; end % happens at the last iteration of the loop
                    TEXT.Draw( sprintf( '%d', round(val) ), 'Active' );
                    switch side
                        case 'Left'
                            HAND.Draw('Left' ,'Active' );
                            HAND.Draw('Right','Passive');
                        case 'Right'
                            HAND.Draw('Left' ,'Passive');
                            HAND.Draw('Right','Active' );
                    end
                    CURSOR.Update();
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    % Flip
                    flip_onset = Screen('Flip', wPtr);
                    SR.AddSample([ flip_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                    
                end % while
                
                % Stability
                sample_stop = SR.SampleCount;
                data        = zeros(size(Stability.Header));
                data(1:6)   = [prev_onset-StartTime block trial side_num sample_start sample_stop];
                Stability.AddSample(data); % the rest will b filled later, in post-processing
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % if ESCAPE is pressed
        if EXIT
            StopTime = secs;
            
            % Record StopTime
            ER.AddStopTime( 'StopTime', StopTime - StartTime );
            
            sca;
            Priority(0);
            ShowCursor;
            
            fprintf('ESCAPE key pressed \n');
            break
        end
        
    end % for
    
    
    %% End of task execution stuff
    
    % Save some values
    S.StartTime = StartTime;
    S.StopTime  = StopTime;
    
    PTB_ENGINE.FinilizeRecorders();
    
    % Close parallel port
    if S.ParPort, CloseParPort(); end
    
    % Diagnotic
    switch S.OperationMode
        case 'Acquisition'
        case 'FastDebug'
            % plotDelay(EP,ER);
        case 'RealisticDebug'
            % plotDelay(EP,ER);
    end
    
    try % I really don't want to this feature to screw a standard task execution
        if exist('moviePtr','var')
            PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
        end
    catch
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
    
    if exist('moviePtr','var') %#ok<UNRCH>
        PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
    end
    
end % try

end % function