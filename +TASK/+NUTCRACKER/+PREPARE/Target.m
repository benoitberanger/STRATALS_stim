function [ TARGET ] = Target()
global S

TARGET               = PTB_OBJECTS.VIDEO.Target();
TARGET.dim           = S.TaskParam.Target.Size * S.PTB.Video.X_total_px;                            % dim == total size (px)
TARGET.width         = S.TaskParam.Target.Size * S.PTB.Video.X_total_px * S.TaskParam.Target.Width; % width == arm size (px)
TARGET.color_Active  = S.TaskParam.Target.color_Active;                                                    % [R G B a] (0..255)
TARGET.color_Passive = S.TaskParam.Target.color_Passive;
TARGET.pos_X         = S.TaskParam.Target.pos_X    * S.PTB.Video.X_total_px;
TARGET.pos_Low       = S.TaskParam.Target.pos_Low  * S.PTB.Video.Y_total_px;
TARGET.pos_High      = S.TaskParam.Target.pos_High * S.PTB.Video.Y_total_px;

TARGET.LinkToWindowPtr(S.PTB.Video.wPtr);
TARGET.AssertReady();


end % function
