function [newX, newY] = QueryMouseData( wPtr, Xcenter, Ycenter )

% Fetch data
[x,y] = GetMouse(wPtr); % (x,y) in PTB coordiantes

% PTB coordinates to Origin coordinates
newX = x - Xcenter;
newY = y - Ycenter;

end % function