classdef Hand < PTB_OBJECTS.VIDEO.Base
    %HADN Class to prepare and draw the hand sprite
    
    
    %% Properties
    
    properties
        
        % Parameters
        
        fpath         = '' % fullpath of the image file
        
        color_Passive = zeros(0,4) % [R G B] from 0 to 255
        color_Active  = zeros(0,4) % [R G B] from 0 to 255
        
        pos_Left                   % px
        pos_Right                  % px
        pos_Y                      % px
        size                       % px
        
        % Internal variables
        X
        alpha
        
        rect_Base
        scale_factor
        rect_Scaled
        rect
        
        texPtr_Left
        texPtr_Right
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
