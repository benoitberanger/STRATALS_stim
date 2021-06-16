classdef Target < PTB_OBJECTS.VIDEO.Base
    %TARGET Class to prepare and horizontal rectangle PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim           = zeros(0)   % size of cross arms, in pixels
        width         = zeros(0)   % width of each arms, in pixels
        color_Active  = zeros(0,4) % [R G B a] from 0 to 255
        color_Passive = zeros(0,4) % [R G B a] from 0 to 255
        pos_Left                   % px
        pos_Right                  % px
        pos_Low                    % px
        pos_High                   % px
        
        % Internal variables
        
        rect          = zeros(1,4) % coordinates, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
