classdef Cursor < PTB_OBJECTS.VIDEO.Target
    %CURSOR Class to prepare and horizontal rectangle PTB that will move
    
    %% Properties
    
    properties
        
        % Parameters
        
        value_Left  = 0          % height, ratio from 0 to 1
        value_Right = 0          % height, ratio from 0 to 1
        device      = ''         % 'Nutcracke' or 'Mouse'
        
        % Internal variables
        
        X                      % from Query*Data
        Y                      % from Query*Data
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
