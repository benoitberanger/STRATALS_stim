function Rescale( self, new_size )

if nargin > 1
    self.size = new_size;
end

self.scale_factor =  self.size / size(self.X,1);

self.rect_Scaled = ScaleRect( self.rect_Base, self.scale_factor, self.scale_factor );

end
