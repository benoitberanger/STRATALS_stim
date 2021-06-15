function [ TargetLEFT, TargetRIGHT ] = Target()
global S

% LEFT
TargetLEFT = PTB_OBJECTS.VIDEO.Bar(                                                   ...
S.TaskParam.TargetLEFT.Size * S.PTB.Video.X_total_px                                , ... % dim == total size (px)
S.TaskParam.TargetLEFT.Size * S.PTB.Video.X_total_px * S.TaskParam.TargetLEFT.Width , ... % width == arm size (px)
S.TaskParam.TargetLEFT.Color                                                        , ... % [R G B a] (0..255)
S.TaskParam.TargetLEFT.Position .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ]  ... % [Xpos Ypos] (px)
);

TargetLEFT.LinkToWindowPtr(S.PTB.Video.wPtr);
TargetLEFT.AssertReady();

% RIGHT
TargetRIGHT = TargetLEFT.CopyObject();
TargetRIGHT.center = S.TaskParam.TargetRIGHT.Position .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ];
TargetRIGHT.GenerateCoords();

end % function
