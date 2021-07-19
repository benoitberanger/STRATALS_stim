function MakeTexture( self )

assert(~isempty(self.wPtr), 'use LinkToWindowPtr first')

texPtr_Left  = Screen( 'MakeTexture', self.wPtr,        cat(3, self.X, self.alpha)  );
texPtr_Right = Screen( 'MakeTexture', self.wPtr, fliplr(cat(3, self.X, self.alpha)) );

self.texPtr_Left  = texPtr_Left;
self.texPtr_Right = texPtr_Right;

end % function
