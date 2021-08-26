function p = Graphics( p )

p.FixationCross.Size     = 0.10;          %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;          % Width_px =    Size_px * Width
p.FixationCross.Color    = [000 000 000]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];   % Position_px = [ScreenX_px ScreenY_px] .* Position

p.Target.Size          = 0.40;          %  Size_px = ScreenX_px * Size
p.Target.Width         = 0.05;          % Width_px =    Size_px * Width
p.Target.Color         = [255 255 255]; % [R G B], from 0 to 255
p.Target.pos_X         = 0.50;          % always a ratio from the corresponding dimension
p.Target.pos_Low       = 0.75;
p.Target.pos_High      = 0.25;
p.Target.color_Active  = [000 255 000]; % for ProduceForce & Hold
p.Target.color_Passive = [255 000 000]; % for Rest

p.Cursor.Size          = p.Target.Size  * 0.95;
p.Cursor.Width         = p.Target.Width * 0.90;
p.Cursor.pos_X         = p.Target.pos_X;
p.Cursor.pos_Low       = p.Target.pos_Low;
p.Cursor.pos_High      = p.Target.pos_High;
p.Cursor.color_Active  = [255 255 255]; % for ProduceForce & Hold
p.Cursor.color_Passive = [000 000 000]; % wont be used

p.Hand.file          = 'hand.png';    % files have to be in 'img\'
p.Hand.autocrop      = 1;             % auto-crop
p.Hand.invert        = 1;             % useful when the image is black instead of white
p.Hand.FWHM          = 10;            % px : kernel size for smoothing the image
p.Hand.pos_Left      = 0.45;
p.Hand.pos_Right     = 0.55;
p.Hand.pos_Y         = 0.90;
p.Hand.scale         = 0.10;          %  Size_px = ScreenX_px * scale
p.Hand.color_Active  = [000 128 000]; % for ProduceForce & Hold
p.Hand.color_Passive = [025 025 025]; % wont be used

end % function
