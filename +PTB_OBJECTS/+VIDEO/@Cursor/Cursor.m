classdef Cursor < PTB_OBJECTS.VIDEO.Base
    %CURSOR Class to prepare and horizontal rectangle PTB that will move
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim          = zeros(0)   % size of cross arms, in pixels
        width        = zeros(0)   % width of each arms, in pixels
        baseColor    = zeros(0,4) % [R G B a] from 0 to 255
        currentColor = zeros(0,4) % [R G B a] from 0 to 255
        pos_Left                  % px
        pos_Right                 % px
        pos_Low                   % px
        pos_High                  % px
        value        = 0          % height, ratio from 0 to 1
        side         = 'L'
        
        % Internal variables
        
        allCoords = zeros(1,4) % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
