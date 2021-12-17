function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.NUTCRACKER.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.NUTCRACKER.PREPARE.FixationCross();
    TARGET        = TASK.NUTCRACKER.PREPARE.Target       ();
    CURSOR        = TASK.NUTCRACKER.PREPARE.Cursor       ();
    HAND          = TASK.NUTCRACKER.PREPARE.Hand         ();
    
    
    %% Shortcuts
    
    ER          = S.ER;
    SR          = S.SR;
    RT_produce  = S.RT_produce;
    RT_rest     = S.RT_rest;
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
        modulator     = EP.Data{evt,7};
        
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
                FIXATIONCROSS.Draw();
                HAND.Draw('Left' ,'Passive');
                HAND.Draw('Right','Passive');
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                
                % Flip at the right moment
                real_onset = Screen('Flip', wPtr);
                prev_onset = real_onset;
                CURSOR.Update();
                SR.AddSample([ real_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    FIXATIONCROSS.Draw();
                    HAND.Draw('Left' ,'Passive');
                    HAND.Draw('Right','Passive');
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    flip_onset = Screen('Flip', wPtr);
                    CURSOR.Update();
                    SR.AddSample([ flip_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                    
                    
                end % while
                
                
            case {'Trial_L_Produce', 'Trial_R_Produce'} % -----------------
                
                % Logs
                fprintf('block=%d   trial=%d   side=%5s   modulator=%d%%   ', block, trial, side, modulator*100)
                
                % Draw
                TARGET.Draw('High','Active', modulator);
                switch side
                    case 'Left'
                        HAND.Draw('Left' ,'Active' );
                        HAND.Draw('Right','Passive');
                    case 'Right'
                        HAND.Draw('Left' ,'Passive');
                        HAND.Draw('Right','Active' );
                end
                CURSOR.Update();
                CURSOR.Draw(side);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                % Flip at the right moment
                desired_onset = prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                SR.AddSample([ real_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                flag_RT_produce = 0;
                while 1
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw('High','Active', modulator);
                    switch side
                        case 'Left'
                            HAND.Draw('Left' ,'Active' );
                            HAND.Draw('Right','Passive');
                        case 'Right'
                            HAND.Draw('Left' ,'Passive');
                            HAND.Draw('Right','Active' );
                    end
                    CURSOR.Update();
                    CURSOR.Draw(side);
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    % Flip
                    flip_onset = Screen('Flip', wPtr);
                    SR.AddSample([ flip_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                    
                    
                    if ~flag_RT_produce && CURSOR.(['value_' side]) >= TaskParam.thresholdRT
                        flag_RT_produce = 1;
                        RT_produce.AddSample([prev_onset-StartTime block trial side_num flip_onset-prev_onset])
                        % Logs
                        fprintf('RT_produce=%4dms   ', round((flip_onset-prev_onset)*1000) )
                    elseif CURSOR.(['value_' side]) >= modulator % cursor reached target
                        break;
                    end
                    
                end % while
                
                
            case {'Trial_L_Hold', 'Trial_R_Hold'} % -----------------------
                
                % Draw
                TARGET.Draw('High','Active', modulator);
                switch side
                    case 'Left'
                        HAND.Draw('Left' ,'Active' );
                        HAND.Draw('Right','Passive');
                    case 'Right'
                        HAND.Draw('Left' ,'Passive');
                        HAND.Draw('Right','Active' );
                end
                CURSOR.Update();
                CURSOR.Draw(side);
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
                next_onset = prev_onset + evt_duration - slack;
                while secs < next_onset
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw('High','Active', modulator);
                    switch side
                        case 'Left'
                            HAND.Draw('Left' ,'Active' );
                            HAND.Draw('Right','Passive');
                        case 'Right'
                            HAND.Draw('Left' ,'Passive');
                            HAND.Draw('Right','Active' );
                    end
                    CURSOR.Update();
                    CURSOR.Draw(side);
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
                
                
            case {'Trial_L_Rest', 'Trial_R_Rest'} % -----------------------
                
                % Draw
                TARGET.Draw('Low','Passive');
                switch side
                    case 'Left'
                        HAND.Draw('Left' ,'Active' );
                        HAND.Draw('Right','Passive');
                    case 'Right'
                        HAND.Draw('Left' ,'Passive');
                        HAND.Draw('Right','Active' );
                end
                CURSOR.Update();
                CURSOR.Draw(side);
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                % Flip at the right moment
                desired_onset = prev_onset + prev_duration - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                prev_onset = real_onset;
                SR.AddSample([ real_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                flag_RT_rest = 0;
                next_onset = Inf;
                while secs < next_onset
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(ESCAPE);
                        if EXIT, break, end
                    end
                    
                    % Draw
                    TARGET.Draw('Low','Passive');
                    switch side
                        case 'Left'
                            HAND.Draw('Left' ,'Active' );
                            HAND.Draw('Right','Passive');
                        case 'Right'
                            HAND.Draw('Left' ,'Passive');
                            HAND.Draw('Right','Active' );
                    end
                    CURSOR.Update();
                    CURSOR.Draw(side);
                    if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrame(wPtr,moviePtr); end
                    
                    flip_onset = Screen('Flip', wPtr);
                    SR.AddSample([ flip_onset-StartTime CURSOR.X CURSOR.Y CURSOR.value_Left CURSOR.value_Right ]);
                    
                    if ~flag_RT_rest && CURSOR.(['value_' side]) <= (modulator*(1-TaskParam.thresholdRT))
                        flag_RT_rest = 1;
                        RT_rest.AddSample([prev_onset-StartTime block trial side_num flip_onset-prev_onset])
                        % Logs
                        fprintf('RT_rest=%4dms   \n', round((flip_onset-prev_onset)*1000) )
                    elseif abs(CURSOR.(['value_' side])) < 0.05 % cursor reached target
                        if next_onset == Inf
                            next_onset = secs + evt_duration - slack;
                        end
                    end
                    
                end % while
                
                
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
