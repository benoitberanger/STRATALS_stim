function GenerateCoords( self )

hRect = [0 0 self.dim self.width ];

switch self.side
    case 'L'
        pos_LR = self.pos_Left;
    case 'R'
        pos_LR = self.pos_Right;
    otherwise
        error('side ?')
end

self.allCoords = CenterRectOnPoint(hRect, pos_LR, self.pos_High + self.value*(self.pos_Low - self.pos_High));

end % function
