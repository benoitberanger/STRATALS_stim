function QueryMouseData( self )

% Fetch data
[self.X,self.Y] = GetMouse(self.wPtr); % (x,y) in PTB coordiantes

self.value = (self.Y - self.pos_Low) / (self.pos_High - self.pos_Low);

end % function