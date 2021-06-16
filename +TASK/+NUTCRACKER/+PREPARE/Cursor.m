function CURSOR = Cursor()
global S

CURSOR               = PTB_OBJECTS.VIDEO.Cursor();
CURSOR.dim           = S.TaskParam.Cursor.Size * S.PTB.Video.X_total_px;                            % dim == total size (px)
CURSOR.width         = S.TaskParam.Target.Size * S.PTB.Video.X_total_px * S.TaskParam.Cursor.Width; % width == arm size (px)
CURSOR.color_Active  = S.TaskParam.Cursor.color_Active;                                                    % [R G B a] (0..255)
CURSOR.color_Passive = S.TaskParam.Cursor.color_Passive;
CURSOR.pos_Left      = S.TaskParam.Cursor.pos_Left  * S.PTB.Video.X_total_px;
CURSOR.pos_Right     = S.TaskParam.Cursor.pos_Right * S.PTB.Video.X_total_px;
CURSOR.pos_Low       = S.TaskParam.Cursor.pos_Low   * S.PTB.Video.Y_total_px;
CURSOR.pos_High      = S.TaskParam.Cursor.pos_High  * S.PTB.Video.Y_total_px;
CURSOR.device        = S.Device;

CURSOR.LinkToWindowPtr(S.PTB.Video.wPtr);
CURSOR.Update();
CURSOR.AssertReady();


end % function
