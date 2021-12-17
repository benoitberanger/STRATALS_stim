function Draw( self, HL, Color, modulator )

Y = self.(['pos_' HL]);

if nargin > 3 % with modulator
    if     strcmp(HL, 'High')
        Y = (self.pos_High - self.pos_Low) * (modulator/self.max_modulator) + self.pos_Low;
    elseif strcmp(HL, 'Low' )
        Y = self.pos_Low;
    else
        error('High ? Low ?')
    end
end

self.rect = CenterRectArrayOnPoint(...
    [0 0 self.dim self.width],...
    self.pos_X               ,...
    Y                         ...
    );

Screen('FillRect', self.wPtr, self.(['color_' Color]), self.rect);

end % function
