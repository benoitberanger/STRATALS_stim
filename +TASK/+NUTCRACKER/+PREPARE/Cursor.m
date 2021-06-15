function CURSOR = Cursor()
global S

% LEFT
CURSOR              = PTB_OBJECTS.VIDEO.Cursor();
CURSOR.dim          = S.TaskParam.Cursor    .Size * S.PTB.Video.X_total_px;                            % dim == total size (px)
CURSOR.width        = S.TaskParam.TargetLEFT.Size * S.PTB.Video.X_total_px * S.TaskParam.Cursor.Width; % width == arm size (px)
CURSOR.baseColor    = S.TaskParam.Cursor.ColorActif;                                                   % [R G B a] (0..255)
CURSOR.currentColor = CURSOR.baseColor;
CURSOR.pos_Left     = S.TaskParam.Cursor.pos_Left  * S.PTB.Video.X_total_px;
CURSOR.pos_Right    = S.TaskParam.Cursor.pos_Right * S.PTB.Video.X_total_px;
CURSOR.pos_Low      = S.TaskParam.Cursor.pos_Low   * S.PTB.Video.Y_total_px;
CURSOR.pos_High     = S.TaskParam.Cursor.pos_High  * S.PTB.Video.Y_total_px;


CURSOR.GenerateCoords();
CURSOR.LinkToWindowPtr(S.PTB.Video.wPtr);
CURSOR.AssertReady();


end % function
