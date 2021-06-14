function GenerateCoords( self )

hRect = [0 0 self.dim   self.width ];

self.allCoords = CenterRectOnPoint(hRect, self.center(1), self.center(2));

end % function
