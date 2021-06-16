function Update( self )

switch self.device
    case 'Nutcracker'
        self.QueryJoystickData();
    case 'Mouse'
        self.QueryMouseData();
end

end % function
