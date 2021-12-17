function CURSOR = Cursor()
global S

CURSOR               = PTB_OBJECTS.VIDEO.Cursor();
CURSOR.dim           = S.TaskParam.Cursor.Size * S.PTB.Video.X_total_px;                            % dim == total size (px)
CURSOR.width         = S.TaskParam.Target.Size * S.PTB.Video.X_total_px * S.TaskParam.Cursor.Width; % width == arm size (px)
CURSOR.color_Active  = S.TaskParam.Cursor.color_Active;                                                    % [R G B a] (0..255)
CURSOR.color_Passive = S.TaskParam.Cursor.color_Passive;
CURSOR.pos_X         = S.TaskParam.Cursor.pos_X    * S.PTB.Video.X_total_px;
CURSOR.pos_Low       = S.TaskParam.Cursor.pos_Low  * S.PTB.Video.Y_total_px;
CURSOR.pos_High      = S.TaskParam.Cursor.pos_High * S.PTB.Video.Y_total_px;
CURSOR.device        = S.Device;
switch S.Task
    case 'Calibration'
        % pass
    case 'Nutcracker'
        CURSOR.factor_Left   = S.calib_Left;
        CURSOR.factor_Right  = S.calib_Right;
        CURSOR.max_modulator = max(S.TaskParam.valueModulator);
end

CURSOR.LinkToWindowPtr(S.PTB.Video.wPtr);
CURSOR.Update();
CURSOR.AssertReady();

end % function
