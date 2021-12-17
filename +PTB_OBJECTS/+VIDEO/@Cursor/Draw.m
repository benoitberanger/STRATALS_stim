function Draw( self, LR )

% recale : value -> Y_pos in pixel
pos_Y = self.(['value_' LR]) * (self.pos_High - self.pos_Low) / self.max_modulator + self.pos_Low;

self.rect = CenterRectArrayOnPoint(...
    [0 0 self.dim self.width] ,...
    self.pos_X                ,...
    pos_Y                      ...
    );

Screen('FillRect', self.wPtr, self.color_Active, self.rect);

end % function
