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
    
    
    %% GO
    
    
catch err
    
    sca;
    Priority( 0 );
    ShowCursor;
    rethrow(err);
    
end % try

end % function
