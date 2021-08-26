function [ TEXT ] = Text()
global S

TEXT = PTB_OBJECTS.VIDEO.Text();

TEXT.size          = S.TaskParam.Text.Size * S.PTB.Video.Y_total_px ;
TEXT.color_Active  = S.TaskParam.Text.color_Active;  % [R G B a] (0..255)
TEXT.color_Passive = S.TaskParam.Text.color_Passive; % [R G B a] (0..255)
TEXT.center        = S.TaskParam.Text.Position .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ]  ; % [Xpos Ypos] (px)

TEXT.GenerateRect();
TEXT.LinkToWindowPtr(S.PTB.Video.wPtr);
TEXT.AssertReady();

end % function
