function Runtime()
global S

try
    %% Tuning of the task
    
    [ EP, TaskParam ] = TASK.NUTCRACKER.Parameters();
    
    
    %% Prepare recorders
    
    [ ER, KL, SR ] = TASK.PrepRecorders( EP );
    
    
    %% Initialize stim objects
    
    
    %% GO
    
    
catch err
    
    sca;
    Priority( 0 );
    ShowCursor;
    rethrow(err);
    
end

end % function
