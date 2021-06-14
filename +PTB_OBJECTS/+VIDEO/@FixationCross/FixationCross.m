classdef FixationCross < PTB_OBJECTS.VIDEO.Base
    %FIXATIONCROSS Class to prepare and draw a fixation cross in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim          = zeros(0)   % size of cross arms, in pixels
        width        = zeros(0)   % width of each arms, in pixels
        baseColor    = zeros(0,4) % [R G B a] from 0 to 255
        currentColor = zeros(0,4) % [R G B a] from 0 to 255
        center       = zeros(0,2) % [ CenterX CenterY ] of the cross, in pixels
        
        % Internal variables
        
        allCoords = zeros(4,2) % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = FixationCross( dim , width ,  color , center )
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                
                self.dim          = dim;
                self.width        = width;
                self.baseColor    = color;
                self.currentColor = color;
                self.center       = center;
                
                % ================== Callback =============================
                
                self.GenerateCoords();
                
            else
                % Create empty instance
            end
            
        end % function
        
    end % methods
    
    
end % class
