classdef Cursor < PTB_OBJECTS.VIDEO.Target
    %CURSOR Class to prepare and horizontal rectangle PTB that will move
    
    %% Properties
    
    properties
        
        % Parameters
        device       = '' % 'Nutcracker' or 'Mouse'
        factor_Left  = 1  % scaling factor
        factor_Right = 1  % scaling factor
        
        % Internal variables
        X                % from Query*Data
        Y                % from Query*Data
        value_Left  = 0  % height, ratio from 0 to 1
        value_Right = 0  % height, ratio from 0 to 1
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
