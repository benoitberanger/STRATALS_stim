function [EXIT, StopTime] = CheckESCAPE(IsESCAPE, StartTime)

EXIT = false;
StopTime = [];

if IsESCAPE
    global S %#ok<TLEV>
    
    EXIT = true;
    StopTime = GetSecs(); % I could get a more accurate onset from the KbCheck, but it's a microsecond difference...
    
    % Record StopTime
    S.ER.AddStopTime( 'StopTime', StopTime - StartTime );
    S.RR.AddStopTime( 'StopTime', StopTime - StartTime );
    
    sca;
    Priority(0);
    ShowCursor;
    
    fprintf('ESCAPE key pressed \n');
    
end

end % function
