function Update( self )

switch self.device
    case 'Nutcracker'
        self.QueryJoystickData();
    case 'Mouse'
        self.QueryMouseData();
end

self.rect = CenterRectArrayOnPoint(...
    [0 0 self.dim self.width]     ,...
    self.X                        ,...
    self.Y                        ...
    );

end % function
