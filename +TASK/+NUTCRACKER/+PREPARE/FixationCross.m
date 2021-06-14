function [ FIXATIONCROSS ] = FixationCross()
global S

FIXATIONCROSS = PTB_OBJECTS.VIDEO.FixationCross(                                           ...
S.TaskParam.FixationCross.Size * S.PTB.Video.Y_total_px                                  , ... % dim == total size (px)
S.TaskParam.FixationCross.Size * S.PTB.Video.Y_total_px * S.TaskParam.FixationCross.Width, ... % width == arm size (px)
S.TaskParam.FixationCross.Color                                                          , ... % [R G B a] (0..255)
S.TaskParam.FixationCross.Position .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ]    ... % [Xpos Ypos] (px)
);

FIXATIONCROSS.LinkToWindowPtr(S.PTB.Video.wPtr);
FIXATIONCROSS.AssertReady();

end % function
