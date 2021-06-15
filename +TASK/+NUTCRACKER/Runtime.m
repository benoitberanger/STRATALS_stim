function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.NUTCRACKER.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    [ ER, KL, SR ] = TASK.PrepRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS               = TASK.NUTCRACKER.PREPARE.FixationCross();
    [ TargetLEFT, TargetRIGHT ] = TASK.NUTCRACKER.PREPARE.Target       ();
    CURSOR                      = TASK.NUTCRACKER.PREPARE.Cursor       ();
    
    
    %% Shortcuts
    
    wPtr        = S.PTB.Video.wPtr;
    colorActif  = S.TaskParam.Cursor.ColorActif ;
    colorPassif = S.TaskParam.Cursor.ColorPassif;
    
    
    %% GO
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                % Fetch initialization data
                switch S.Device
                    case 'Nutcracker'
                        [X, Y] = TASK.QueryJoystickData();
                    case 'Mouse'
                        SetMouse(CURSOR.pos_Left,CURSOR.pos_Low);
                        [X, Y] = TASK.QueryMouseData( wPtr, CURSOR.pos_Left, CURSOR.pos_Low );
                end
                
                FIXATIONCROSS.Draw();
                Screen('Flip',wPtr);
                
                StartTime = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = PTB_ENGINE.StopTimeEvent( StartTime, evt );
                
                
            case 'BlockRest' % ---------------------------------------------
                
                
                
            case {'Trial_L_Produce', 'Trial_R_Produce'} % -----------------
                
                
               
                
            case 'Outcome' %-----------------------------------------------
                
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
catch err
    
    sca;
    Priority( 0 );
    ShowCursor;
    
    switch S.Device
        case 'Nutcracker'
            clear joymex2
    end
    
    rethrow(err);
    
end % try

end % function
