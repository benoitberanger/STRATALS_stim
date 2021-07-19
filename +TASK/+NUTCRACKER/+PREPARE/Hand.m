function HAND = Hand()
global S

HAND       = PTB_OBJECTS.VIDEO.Hand();
HAND.fpath = fullfile(fileparts(which('project_name')),'img',S.TaskParam.Hand.file);

HAND.LoadImg( S.TaskParam.Hand.autocrop, S.TaskParam.Hand.invert );
HAND.LinkToWindowPtr(S.PTB.Video.wPtr);
HAND.MakeTexture();

HAND.color_Active  = S.TaskParam.Hand.color_Active;
HAND.color_Passive = S.TaskParam.Hand.color_Passive;

HAND.pos_Left      = S.TaskParam.Hand.pos_Left  * S.PTB.Video.X_total_px;
HAND.pos_Right     = S.TaskParam.Hand.pos_Right * S.PTB.Video.X_total_px;
HAND.pos_Y         = S.TaskParam.Hand.pos_Y     * S.PTB.Video.Y_total_px;
HAND.size          = S.TaskParam.Hand.scale     * S.PTB.Video.X_total_px;
HAND.Rescale(); % apply the "size" parameter

% HAND.AssertReady();

end % function
