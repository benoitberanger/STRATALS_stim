function QueryMouseData( self )

% Fetch data
[self.X,self.Y] = GetMouse(self.wPtr); % (x,y) in PTB coordiantes

% value [0..1] => [pos_Low..pos_High]
self.value_Left  = (self.Y - self.pos_Low) / (self.pos_High - self.pos_Low);
self.value_Right = (self.X - self.pos_Low) / (self.pos_High - self.pos_Low);

end % function