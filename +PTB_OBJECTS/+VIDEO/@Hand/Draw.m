function Draw( self, color )

if nargin < 2
    color = [];
end

Screen('DrawTexture', self.wPtr, self.texPtr, [], self.rect_Base,[],[],[],color);

end % function
