function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.NUTCRACKER.Parameters( S.OperationMode );
    
    
    %% Prepare recorders
    
    [ ER, KL, SR ] = TASK.PrepRecorders( EP );
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.NUTCRACKER.PREPARE.FixationCross();
    
    
    %% GO
    
    
catch err
    
    sca;
    Priority( 0 );
    ShowCursor;
    rethrow(err);
    
end

end % function
