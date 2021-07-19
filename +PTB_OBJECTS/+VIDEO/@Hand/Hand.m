classdef Hand < PTB_OBJECTS.VIDEO.Base
    %HADN Class to prepare and draw the hand sprite
    
    
    %% Properties
    
    properties
        
        % Parameters
        
        fpath = '' % fullpath of the image file
        
        % Internal variables
        X
        alpha
        
        rect_Base
        
        texPtr
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
